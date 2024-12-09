import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ranking_model.dart';

class RankingService {
  final _db = FirebaseFirestore.instance;

  Future<void> addRanking(RankingModel ranking) async {
    await _db.collection('rankings').add(ranking.toMap());
  }

  Future<List<RankingModel>> getRankings() async {
    try {
      final rankingSnapshot = await _db.collection('rankings').get();

      List<Future<RankingModel>> rankingFutures = rankingSnapshot.docs.map((doc) async {
        final rankingData = doc.data();

        // Get the DocumentReference from user_id field
        DocumentReference userRef = rankingData['user_id'];

        try {
          // Fetch user document
          final userDoc = await userRef.get();
          final userData = userDoc.data() as Map<String, dynamic>;

          // Create RankingModel with user data
          return RankingModel.fromMap({
            ...rankingData,
            'user_id': userRef.path, // Convert reference to path string
            'user_name': userData['full_name'] ?? 'Unknown',
            'avatar': userData['profile_picture']
          }, doc.id);
        } catch (e) {
          print('Error fetching user data: $e');
          // Return ranking with default user name if user fetch fails
          return RankingModel.fromMap({
            ...rankingData,
            'user_id': userRef.path,
            'user_name': 'Unknown User',
            'avatar': 'https://res.cloudinary.com/dvzjb1o3h/image/upload/v1727704410/x6xaehqt16rjvnvhofv3.jpg'
          }, doc.id);
        }
      }).toList();

      return Future.wait(rankingFutures);
    } catch (e) {
      print('Error in getRankings: $e');
      throw e;
    }
  }


  Future<void> updateRanking(RankingModel ranking) async {
    await _db.collection('rankings').doc(ranking.id).update(ranking.toMap());
  }

  Future<void> deleteRanking(String id) async {
    await _db.collection('rankings').doc(id).delete();
  }
}