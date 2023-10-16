import 'package:appwrite/appwrite.dart';

import '../constants.dart' as constants;
import '../entities/grocery.dart';
import '../services/appwrite.dart';

class GroceriesService {
  final Databases _databases = Databases(Appwrite.instance.client);

  Future<List<Grocery>> fetch() async {
    final documentList = await _databases.listDocuments(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.appwriteCollectionId_groceries,
    );
    return documentList.documents.map((d) => Grocery.fromMap(d.data)).toList();
  }

  Future<Grocery> create({required String content}) async {
    final document = await _databases.createDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.appwriteCollectionId_groceries,
      documentId: ID.unique(),
      data: {"content": content},
    );

    return Grocery.fromMap(document.data);
  }

  Future<Grocery> update({required Grocery grocery}) async {
    final document = await _databases.updateDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.appwriteCollectionId_groceries,
      documentId: grocery.id,
      data: grocery.toMap(),
    );

    return Grocery.fromMap(document.data);
  }

  Future<void> delete({required String id}) async {
    return _databases.deleteDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.appwriteCollectionId_groceries,
      documentId: id,
    );
  }
}
