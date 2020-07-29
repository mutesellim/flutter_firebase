import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreIslemleri extends StatefulWidget {
  @override
  _FirestoreIslemleriState createState() => _FirestoreIslemleriState();
}

class _FirestoreIslemleriState extends State<FirestoreIslemleri> {
  final Firestore _firestore = Firestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firestore Islemleri"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Veri Ekle"),
              color: Colors.green,
              onPressed: _veriEkle,
            ),
            RaisedButton(
              child: Text("Transaction Ekle"),
              color: Colors.blue,
              onPressed: _transactionEkle,
            ),
            RaisedButton(
              child: Text("Veri Sil"),
              color: Colors.red,
              onPressed: _veriSil,
            ),
            RaisedButton(
              child: Text("Veri Oku"),
              color: Colors.pink,
              onPressed: _veriOku,
            ),
            RaisedButton(
              child: Text("Veri Sorgula"),
              color: Colors.brown,
              onPressed: _veriSorgula,
            ),
          ],
        ),
      ),
    );
  }

  void _veriEkle() {
    Map<String, dynamic> mehmetEkle = Map();
    mehmetEkle['ad'] = "mehmet updated";
    mehmetEkle['lisanMezunu'] = true;
    mehmetEkle['lisanMezunu2'] = true;
    mehmetEkle['lisanMezunu23'] = true;
    mehmetEkle['okul'] = "ege";

    _firestore
        .collection("users")
        .document("mehmet_altunbilek")
        .setData(mehmetEkle, merge: true)
        .then((v) => debugPrint("mehmet eklendi"));

    _firestore
        .collection("users")
        .document("hasan_yilmaz")
        .setData({'ad': 'Hasan', 'cinsiyet': 'erkek'}).whenComplete(
            () => debugPrint("hasan eklendi"));

    _firestore.document("/users/ayse").setData({'ad': 'ayse'});

    _firestore.collection("users").add({'ad': 'can', 'yas': 35});

    String yeniKullaniciID =
        _firestore.collection("users").document().documentID;
    debugPrint("yeni doc id: $yeniKullaniciID");
    _firestore
        .document("users/$yeniKullaniciID")
        .setData({'yas': 30, 'userID': '$yeniKullaniciID'});

    _firestore.document("users/mehmet_altunbilek").updateData({
      'okul': 'ege üniversitesi',
      'yas': 60,
      'eklenme': FieldValue.serverTimestamp(),
      'begeniSayisi': FieldValue.increment(10)
    }).then((v) {
      debugPrint("mehmet güncellendi");
    });
  }

  void _transactionEkle() {
    final DocumentReference mehmetRef =
        _firestore.document("users/mehmet_altunbilek");

    debugPrint("doc id:" + mehmetRef.documentID);

    _firestore.runTransaction((Transaction transaction) async {
      DocumentSnapshot mehmetData = await mehmetRef.get();

      debugPrint("doc id:" + mehmetData.documentID);

      if (mehmetData.exists) {
        var mehmetninParasi = mehmetData.data['para'];

        if (mehmetninParasi > 100) {
          await transaction
              .update(mehmetRef, {'para': (mehmetninParasi - 100)});
          await transaction.update(_firestore.document("users/hasan_yilmaz"),
              {'para': FieldValue.increment(100)});
        } else {
          debugPrint("yetersiz bakiye");
        }
      } else {
        debugPrint("mehmet dökümanı yok");
      }
    });
  }

  void _veriSil() {
    //Döküman silme
    _firestore.document("users/ayse").delete().then((aa) {
      debugPrint("ayse silindi");
    }).catchError((e) => debugPrint("Silerken hata cıktı" + e.toString()));

    _firestore
        .document("users/hasan_yilmaz")
        .updateData({'cinsiyet': FieldValue.delete()}).then((aa) {
      debugPrint("cinsiyet silindi");
    }).catchError((e) => debugPrint("Silerken hata cıktı" + e.toString()));
  }

  Future _veriOku() async {
    //tek bir dökümanın okunması
    DocumentSnapshot documentSnapshot =
        await _firestore.document("users/mehmet_altunbilek").get();
    debugPrint("Döküman id:" + documentSnapshot.documentID);
    debugPrint("Döküman var mı:" + documentSnapshot.exists.toString());
    debugPrint("Döküman string: " + documentSnapshot.toString());
    debugPrint("bekleyen yazma var mı:" +
        documentSnapshot.metadata.hasPendingWrites.toString());
    debugPrint("cacheden mi geldi:" +
        documentSnapshot.metadata.isFromCache.toString());
    debugPrint("cacheden mi geldi:" + documentSnapshot.data.toString());
    debugPrint("cacheden mi geldi:" + documentSnapshot.data['ad']);
    debugPrint("cacheden mi geldi:" + documentSnapshot.data['para'].toString());
    documentSnapshot.data.forEach((key, deger) {
      debugPrint("key : $key deger :deger");
    });

    //koleksiyonun okunması
    _firestore.collection("users").getDocuments().then((querySnapshots) {
      debugPrint("User koleksiyonundaki eleman sayısı:" +
          querySnapshots.documents.length.toString());

      for (int i = 0; i < querySnapshots.documents.length; i++) {
        debugPrint(querySnapshots.documents[i].data.toString());
      }

      //anlık değişikliklerin dinlenmesi
      DocumentReference ref =
          _firestore.collection("users").document("mehmet_altunbilek");
      ref.snapshots().listen((degisenVeri) {
        debugPrint("anlık :" + degisenVeri.data.toString());
      });

      _firestore.collection("users").snapshots().listen((snap) {
        debugPrint(snap.documents.length.toString());
      });
    });
  }

  void _veriSorgula() async {
    var dokumanlar = await _firestore
        .collection("users")
        .where("email", isEqualTo: 'ayse@ayse.com')
        .getDocuments();
    for (var dokuman in dokumanlar.documents) {
      debugPrint(dokuman.data.toString());
    }

    var limitliGetir =
        await _firestore.collection("users").limit(3).getDocuments();
    for (var dokuman in limitliGetir.documents) {
      debugPrint("Limitli getirenler" + dokuman.data.toString());
    }

    var diziSorgula = await _firestore
        .collection("users")
        .where("dizi", arrayContains: 'breaking bad')
        .getDocuments();
    for (var dokuman in diziSorgula.documents) {
      debugPrint("Dizi şartı ile getirenler" + dokuman.data.toString());
    }

    var stringSorgula = await _firestore
        .collection("users")
        .orderBy("email")
        .startAt(['mehmet']).endAt(['mehmet' + '\uf8ff']).getDocuments();
    for (var dokuman in stringSorgula.documents) {
      debugPrint("String sorgula ile getirenler" + dokuman.data.toString());
    }

    _firestore
        .collection("users")
        .document("mehmet_altunbilek")
        .get()
        .then((docSnap) {
      debugPrint("mehmetnin verileri" + docSnap.data.toString());

      _firestore
          .collection("users")
          .orderBy('begeni')
          .endAt([docSnap.data['begeni']])
          .getDocuments()
          .then((querySnap) {
            if (querySnap.documents.length > 0) {
              for (var bb in querySnap.documents) {
                debugPrint("mehmetnin begenisinden fazla olan user:" +
                    bb.data.toString());
              }
            }
          });
    });
  }
}
