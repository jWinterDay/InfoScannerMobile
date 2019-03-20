import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';
import 'dart:async';

import '../resources/project_repository.dart';
import '../models/project_model.dart';


Function projectEq = const ListEquality().equals;

class ProjectsBloc {
  final _projectRepository = ProjectRepository();
  final _projectsFetcher = PublishSubject<List<Project>>();

  StreamSink<List<Project>> get inSink => _projectsFetcher.sink;
  Observable<List<Project>> get allProjectsStream => _projectsFetcher.stream;

  //constructor
  ProjectsBloc() {
    allProjectsStream
      .distinct((old, next) {
        List<String> oldGuids = old.map((item) => item.projectGuid).toList();
        List<String> nextGuids = next.map((item) => item.projectGuid).toList();

        print('equals: ${projectEq(oldGuids, nextGuids)}');

        return projectEq(oldGuids, nextGuids);
      })
      //.debounce(Duration(milliseconds: 500))
      //.interval(Duration(seconds: 2))
      .listen(syncAllProjects);
  }

  syncAllProjects(List<Project> data) async {
    var m = data.map((p) => p.projectId).toList();
    print('data from listen event: $m');
  }

  fetchAllProjects() async {
    List<Project> projectList = await _projectRepository.fetchAllProjects();
    inSink.add(projectList);
  }

  addNewProject(Project project) async {
    await _projectRepository.addProjects(project);
    fetchAllProjects();
  }

  updateProject(Project project) async {
    await _projectRepository.updateProjects(project);
    //fetchAllProjects();
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