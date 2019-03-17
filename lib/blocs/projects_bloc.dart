import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';

import '../resources/project_repository.dart';
import '../models/project_model.dart';


Function projectEq = const ListEquality().equals;

class ProjectsBloc {
  final _projectRepository = ProjectRepository();
  final _projectsFetcher = PublishSubject<List<Project>>();

  Observable<List<Project>> get allProjects => _projectsFetcher.stream;

  //constructor
  ProjectsBloc() {
    allProjects
      .distinct((old, next) {
        List<String> oldGuids = old.map((item) => item.projectGuid).toList();
        List<String> nextGuids = next.map((item) => item.projectGuid).toList();

        return projectEq(oldGuids, nextGuids);
      })
      .debounce(Duration(milliseconds: 500))
      .map((list) => syncAllProjects(list))
      .listen((data) {

      });
  }

  syncAllProjects(List<Project> list) async {
    //print('result list ids: ${list.map((item) => item.projectId)}');
    print(list);
  }

  fetchAllProjects() async {
    List<Project> projectList = await _projectRepository.fetchAllProjects();
    _projectsFetcher.sink.add(projectList);
  }

  addNewProject(Project project) async {
    await _projectRepository.addProjects(project);
    fetchAllProjects();
  }

  preRemoveProject(Project project) async {
    await _projectRepository.preRemoveProject(project);
    fetchAllProjects();
  }

  removeProject(Project project) async {
    await _projectRepository.removeProject(project);
    fetchAllProjects();
  }

  restoreProject(Project project) async {
    await _projectRepository.restoreProject(project);
    fetchAllProjects();
  }

  Future<bool> isCanRemoveProject(Project project) async {
    return await _projectRepository.isCanRemoveProject(project);
  }

  dispose() {
    _projectsFetcher.close();
  }
}

final bloc = ProjectsBloc();