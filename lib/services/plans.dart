import 'package:appwrite/appwrite.dart';

import '../constants.dart' as constants;
import '../entities/plan.dart';
import '../services/appwrite.dart';

class PlansService {
  final Databases _databases = Databases(Appwrite.instance.client);

  Future<List<Plan>> fetch() async {
    final documentList = await _databases.listDocuments(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.appwriteCollectionId_plans,
    );
    return documentList.documents.map((d) => Plan.fromMap(d.data)).toList();
  }

  Future<Plan> create({required String content}) async {
    final document = await _databases.createDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.appwriteCollectionId_plans,
      documentId: ID.unique(),
      data: {"content": content},
    );

    return Plan.fromMap(document.data);
  }

  Future<Plan> update({required Plan plan}) async {
    final document = await _databases.updateDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.appwriteCollectionId_plans,
      documentId: plan.id,
      data: plan.toMap(),
    );

    return Plan.fromMap(document.data);
  }

  Future<void> delete({required String id}) async {
    return _databases.deleteDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.appwriteCollectionId_plans,
      documentId: id,
    );
  }
}
