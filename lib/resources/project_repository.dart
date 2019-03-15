import 'dart:async';
import 'project_db_api_provider.dart';
import '../models/project_model.dart';

class ProjectRepository {
  final ProjectDbApiProvider _projectProvider = new ProjectDbApiProvider();


  Future<List<Project>> fetchAllProjects() => _projectProvider.getProjects();
  
  addProjects(Project project) => _projectProvider.newProject(project);
}