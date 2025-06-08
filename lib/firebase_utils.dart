import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/my_user.dart';
import 'model/task.dart';

class FirebaseUtils {
  static CollectionReference<Task> getTasksCollections(String uId) {
    return getUsersCollection()
        .doc(uId)
        .collection(Task.collectionName)
        .withConverter<Task>(
            fromFirestore: (snapshot, _) =>
                Task.fromFireStore(snapshot.data()!),
            toFirestore: (task, _) => task.toFireStore());
  }

  static Future<void> addTaskToFireStore(Task task, String uId) async {
    var collectionRef = getTasksCollections(uId);
    var documentRef = collectionRef.doc();
    task.id = documentRef.id;
    return await documentRef.set(task);
  }

  static Future<List<Task>> getAllTasks(String uId) async {
    List<Task> tasks = [];
    QuerySnapshot<Task> querySnapshot = await getTasksCollections(uId).get();
    // List<QueryDocumentSnapshot<T>> --> List<Task>
    tasks = querySnapshot.docs.map<Task>((doc) => doc.data()).toList();
    return tasks;
  }

  static Future<void> deleteTaskFromFireStore(Task task, String uId) async {
    return await getTasksCollections(uId).doc(task.id).delete();
  }

  static Future<void> updateTask(Task task, String uId) async {
    if (task.id == null || task.id!.isEmpty) {
      throw Exception('Task ID is null or empty, cannot update task');
    }
    return await getTasksCollections(uId)
        .doc(task.id)
        .update(task.toFireStore());
  }

  static CollectionReference<MyUser> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
            fromFirestore: (snapshot, _) =>
                MyUser.fromFireStore(snapshot.data()!),
            toFirestore: (user, _) => user.toFireStore());
  }

  static Future<void> addUserToFireStore(MyUser user) {
    return getUsersCollection().doc(user.id).set(user);
  }

  static Future<MyUser?> readUserFromFireStore(String uId) async {
    var querySnapshot = await getUsersCollection().doc(uId).get();
    return querySnapshot.data();
  }
}
