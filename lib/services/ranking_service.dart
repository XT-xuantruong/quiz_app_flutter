import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ranking_model.dart';

class RankingService {
  final _db = FirebaseFirestore.instance;

  Future<void> addRanking(RankingModel ranking) async {
    await _db.collection('rankings').add(ranking.toMap());
  }

  Future<List<RankingModel>> getRankings() async {
    final snapshot = await _db.collection('rankings').get();
    return snapshot.docs.map((doc) => RankingModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> updateRanking(RankingModel ranking) async {
    await _db.collection('rankings').doc(ranking.id).update(ranking.toMap());
  }

  Future<void> deleteRanking(String id) async {
    await _db.collection('rankings').doc(id).delete();
  }
}