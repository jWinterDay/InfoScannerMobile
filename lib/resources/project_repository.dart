import 'dart:async';
import 'project_db_api_provider.dart';
import '../models/project_model.dart';

class ProjectRepository {
  final ProjectDbApiProvider _projectProvider = new ProjectDbApiProvider();


  Future<List<Project>> fetchAllProjects() => _projectProvider.getProjects();
  
  addProjects(Project project) => _projectProvider.newProject(project);

  updateProjects(Project project) => _projectProvider.udpateProject(project);

  preRemoveProject(Project project) => _projectProvider.preDeleteProject(project);

  removeProject(Project project) => _projectProvider.deleteProject(project);

  restoreProject(Project project) => _projectProvider.restoreProject(project);

  Future<bool> isCanRemoveProject(Project project) => _projectProvider.isCanDeleteProject(project);
}