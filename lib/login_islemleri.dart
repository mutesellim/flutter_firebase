import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginIslemleri extends StatefulWidget {
  @override
  _LoginIslemleriState createState() => _LoginIslemleriState();
}

class _LoginIslemleriState extends State<LoginIslemleri> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String mesaj = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.onAuthStateChanged.listen((user) {
      setState(() {
        if (user != null) {
          mesaj += "\nListener tetiklendi oturum açıldı";
        } else {
          mesaj += "\nListener tetiklendi oturum kapandı";
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Authentication"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text(
                "Email/Şifre Yeni Kullanıcı Oluştur",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightBlueAccent,
              onPressed: _emailveSifreLogin,
            ),
            RaisedButton(
              child: Text(
                "Email/Şifre ile Giriş Yap",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightBlueAccent,
              onPressed: _emailveSifreileGirisYap,
            ),
            RaisedButton(
              child: Text(
                "Çıkış Yap",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightBlueAccent,
              onPressed: _cikisYap,
            ),
            RaisedButton(
              child: Text(
                "Şifremi Unuttum",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightBlueAccent,
              onPressed: _sifremiUnuttum,
            ),
            RaisedButton(
              child: Text(
                "Şifremi Güncelle",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightBlueAccent,
              onPressed: _sifremiGuncelle,
            ),
            RaisedButton(
              child: Text(
                "Email Güncelle",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightBlueAccent,
              onPressed: _emailGuncelle,
            )

          ],
        ),
      ),
    );
  }

  _emailveSifreLogin() async {
    String mail = "ciktieposta@mail.com.tr";
    String sifre = "12345678";
    var authResult = await _auth
        .createUserWithEmailAndPassword(email: mail, password: sifre)
        .catchError((e) => debugPrint("Hata: " + e.toString()));
    var firebaseUser = authResult.user;
    if (firebaseUser != null) {
      firebaseUser.sendEmailVerification().then((data) {
        _auth.signOut();
      }).catchError((e) => debugPrint("Mail Gönderirken hata oluştu $e"));
      setState(() {
        mesaj =
            "Uid: ${firebaseUser.uid} \n mail: ${firebaseUser.email} \n mailOnaylıMı: ${firebaseUser.isEmailVerified}\n Email Gönderildi Lütfen Onaylayın";
      });
      debugPrint(
          "Uid: ${firebaseUser.uid} mail: ${firebaseUser.email} mailOnaylıMı: ${firebaseUser.isEmailVerified}");
    } else {
      setState(() {
        mesaj = "firebase user null";
      });
    }
  }

  void _emailveSifreileGirisYap() {
    String mail = "ciktieposta@mail.com.tr";
    String sifre = "12345678";

    _auth
        .signInWithEmailAndPassword(email: mail, password: sifre)
        .then((oturumAcmisKullaniciAuthResult) {
      var oturumAcmisKullanici = oturumAcmisKullaniciAuthResult.user;
      if (oturumAcmisKullanici.isEmailVerified) {
        mesaj += "\nEmail onaylı kullanıcı yönlendirme yapabilirsin";
      } else {
        mesaj += "\nEmailize mail attık lütfen onaylayın";
        _auth.signOut();
      }
      setState(() {});
    }).catchError((hata) {
      debugPrint(hata.toString());

      setState(() {
        mesaj += "\nEmail/Sifre hatalı";
      });
    });
  }

  void _cikisYap() async {
    if (await _auth.currentUser() != null) {
      _auth.signOut().then((data) {
        setState(() {
          mesaj = "kullanıcı çıkıs yaptı";
        });
      }).catchError((hata) {
        setState(() {
          mesaj = "Cıkış yaparken hata oluştu";
        });
      });
    } else {
      setState(() {
        mesaj = "Oturum Açmış Kullanıcı Yok";
      });
    }
  }

  void _sifremiUnuttum() {
    String mail = "ciktieposta@mail.com.tr";
    _auth
        .sendPasswordResetEmail(email: mail)
        .then((value) {})
        .catchError((hata) {
      setState(() {
        mesaj = "Bir Hata Oluştu";
      });
    });
  }

  void _sifremiGuncelle() async {
    _auth.currentUser().then((user) {
      if (user != null) {
        user.updatePassword("123456789").then((a) {
          setState(() {
            mesaj += "\n Şifre Güncellendi";
          });
        }).catchError((hata) {
          setState(() {
            mesaj += "\n Şifre Güncellerken Hata Oluştu";
          });
        });
      }else{
        setState(() {
          mesaj+="\n Şifre Güncellemek İçin Önce Oturum Açın";
        });
      }
    });
  }

  void _emailGuncelle() {
    _auth.currentUser().then((user) {
      if (user != null) {
        user.updateEmail("mehmet@mehmet.com").then((a) {
          setState(() {
            mesaj += "\n Email Güncellendi";
          });
        }).catchError((hata) {
          setState(() {
            mesaj += "\n Email Güncellerken Hata Oluştu";
          });
        });
      }else{
        setState(() {
          mesaj+="\n Email Güncellemek İçin Önce Oturum Açın";
        });
      }
    });
  }
}
