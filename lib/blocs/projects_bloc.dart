import '../resources/project_repository.dart';
import '../models/project_model.dart';
import 'package:rxdart/rxdart.dart';

class ProjectsBloc {
  final _projectRepository = ProjectRepository();
  final _projectsFetcher = PublishSubject<List<Project>>();

  Observable<List<Project>> get allProjects => _projectsFetcher.stream;

  fetchAllProjects() async {
    List<Project> projectList = await _projectRepository.fetchAllProjects();
    _projectsFetcher.sink.add(projectList);
  }

  addNewProject(Project project) async {
    await _projectRepository.addProjects(project);
    List<Project> projectList = await _projectRepository.fetchAllProjects();
    _projectsFetcher.sink.add(projectList);
  }

  dispose() {
    _projectsFetcher.close();
  }
}

final bloc = ProjectsBloc();