import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ranking_model.dart';

class RankingService {
  final _db = FirebaseFirestore.instance;

  Future<void> addRanking(RankingModel ranking) async {
    await _db.collection('rankings').add(ranking.toMap());
  }
  Future<RankingModel?> getRankingDetail(String userId) async {
    try {
      final userRe = _db.collection('users').doc(userId);
      final querySnapshot = await _db
          .collection('rankings')
          .where('user_id', isEqualTo: userRe.path)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final rankingDoc = querySnapshot.docs.first;
      final rankingData = rankingDoc.data();

      // Get user reference
      DocumentReference userRef;
      if (rankingData['user_id'] is String) {
        userRef = FirebaseFirestore.instance.doc(rankingData['user_id']);
      } else if (rankingData['user_id'] is DocumentReference) {
        userRef = rankingData['user_id'];
      } else {
        throw Exception("Invalid user_id format for ranking ${rankingDoc.id}");
      }

      try {

        final userDoc = await userRef.get();
        final userData = userDoc.data() as Map<String, dynamic>;

        // Create and return RankingModel with complete information
        return RankingModel.fromMap({
          ...rankingData,
          'user_id': userRef.path,
          'user_name': userData['full_name'] ?? 'Unknown',
          'avatar': userData['profile_picture']
        }, rankingDoc.id);

      } catch (e) {
        print('Error fetching user data for ranking ${rankingDoc.id}: $e');
        // Return ranking with default user data on error
        return RankingModel.fromMap({
          ...rankingData,
          'user_id': userRef.path,
          'user_name': '',
          'avatar': ''
        }, rankingDoc.id);
      }
    } catch (e) {
      print('Error fetching ranking detail: $e');
      return null;
    }
  }

  Future<List<RankingModel>> getRankings() async {
    try {

      final rankingSnapshot = await _db
          .collection('rankings')
          .orderBy('total_score', descending: true)
          .get();
      print(" 1 $rankingSnapshot");
      if (rankingSnapshot.docs.isEmpty) {
        return [];
      }

      List<Future<RankingModel>> rankingFutures = rankingSnapshot.docs.map((doc) async {
        final rankingData = doc.data();
        // Kiểm tra và chuyển đổi user_id từ String thành DocumentReference
        DocumentReference userRef;
        if (rankingData['user_id'] is String) {
          userRef = FirebaseFirestore.instance.doc(rankingData['user_id']); // Chuyển đổi từ String
        } else if (rankingData['user_id'] is DocumentReference) {
          userRef = rankingData['user_id']; // Đã là DocumentReference
        } else {
          throw Exception("Invalid user_id format for ranking ${doc.id}");
        }
        try {
          final userDoc = await userRef.get();
          final userData = userDoc.data() as Map<String, dynamic>;

          return RankingModel.fromMap({
            ...rankingData,
            'user_id': userRef.path, // Convert reference to path string
            'user_name': userData['full_name'] ?? 'Unknown',
            'avatar': userData['profile_picture']
          }, doc.id);

        } catch (e) {
          print('Error fetching user data for ranking ${doc.id}: $e');
          // Return ranking with default user data on error
          return RankingModel.fromMap({
            ...rankingData,
            'user_id': userRef.path,
            'user_name': 'Unknown User',
            'avatar': 'https://res.cloudinary.com/dvzjb1o3h/image/upload/v1727704410/x6xaehqt16rjvnvhofv3.jpg'
          }, doc.id);
        }
      }).toList();

      return await Future.wait(rankingFutures);

    } catch (e) {
      print('Error fetching rankings: $e');
      return [];
    }
  }



  Future<void> updateRanking(RankingModel ranking) async {
    final querySnapshot = await _db
        .collection('rankings')
        .where('user_id', isEqualTo: ranking.user_id)
        .get();

    if (querySnapshot.docs.isEmpty) {
      // Create new ranking if user doesn't have one
      await _db.collection('rankings').add(ranking.toMap());
    } else {
      // Get the current document
      final currentDoc = querySnapshot.docs.first;
      final currentData = currentDoc.data();

      // Add the new score to the existing total
      final int currentTotal = currentData['total_score'] ?? 0;
      final int newTotal = currentTotal + ranking.total_score;

      // Update existing ranking with accumulated score
      await _db.collection('rankings').doc(currentDoc.id).update({
        'total_score': newTotal,
      });
    }
  }

  Future<void> deleteRanking(String id) async {
    await _db.collection('rankings').doc(id).delete();
  }
}