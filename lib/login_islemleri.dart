import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginIslemleri extends StatefulWidget {
  @override
  _LoginIslemleriState createState() => _LoginIslemleriState();
}

class _LoginIslemleriState extends State<LoginIslemleri> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleAuth = GoogleSignIn();
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
              onPressed: _emailveSifreileUserOlustur,
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
            ),
            RaisedButton(
              child: Text(
                "Google ile Giriş Yap",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightBlueAccent,
              onPressed: _googleGiris,
            ),
            RaisedButton(
              child: Text(
                "TelNo ile Giriş Yap",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightBlueAccent,
              onPressed: _telNoGiris,
            ),
            Text(mesaj),
          ],
        ),
      ),
    );
  }

  void _emailveSifreileUserOlustur() async {
    String mail = "ciktieposta@mail.com.tr";
    String sifre = "123456";
    var authResult = await _auth
        .createUserWithEmailAndPassword(
          email: mail,
          password: sifre,
        )
        .catchError((e) => debugPrint("Hata :" + e.toString()));
    var firebaseUser = authResult.user;
    if (firebaseUser != null) {
      firebaseUser.sendEmailVerification().then((data) {
        _auth.signOut();
      }).catchError((e) => debugPrint("Mail gönderirken hata $e"));

      setState(() {
        mesaj =
            "Uid ${firebaseUser.uid} \nmail : ${firebaseUser.email} \nmailOnayı : ${firebaseUser.isEmailVerified}\n Email gönderildi lütfen onaylayın";
      });
      debugPrint(
          "Uid ${firebaseUser.uid} mail : ${firebaseUser.email} mailOnayı : ${firebaseUser.isEmailVerified} ");
    } else {
      setState(() {
        mesaj = "bu mail zaten kullanımda";
      });
    }
  }

  void _emailveSifreileGirisYap() {
    String mail = "ciktieposta@mail.com.tr";
    String sifre = "123456";

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
        _googleAuth.signOut();
        setState(() {
          mesaj += "\nKullanıcı çıkış yaptı";
        });
      }).catchError((hata) {
        setState(() {
          mesaj += "\nÇıkış yaparken hata oluştu $hata";
        });
      });
    } else {
      setState(() {
        mesaj += "\nOturum açmış kullanıcı yok";
      });
    }
  }

  void _sifremiUnuttum() {
    String mail = "ciktieposta@mail.com.tr";
    _auth.sendPasswordResetEmail(email: mail).then((v) {
      setState(() {
        mesaj += "\nSıfırlama maili gönderildi";
      });
    }).catchError((hata) {
      setState(() {
        mesaj += "\nŞifremi unuttum mailinde hata $hata";
      });
    });
  }

  void _sifremiGuncelle() async {
    _auth.currentUser().then((user) {
      if (user != null) {
        user.updatePassword("234567").then((a) {
          setState(() {
            mesaj += "\nŞifre güncellendi";
          });
        }).catchError((hata) {
          setState(() {
            mesaj += "\nŞifre güncellenirken hata olustur $hata";
          });
        });
      } else {
        setState(() {
          mesaj += "\nŞifre güncellemek için önce oturum açın";
        });
      }
    }).catchError((hata) {
      setState(() {
        mesaj += "\nKullanıcı getirilirken cıkan hata : $hata";
      });
    });
  }

  void _emailGuncelle() {
    _auth.currentUser().then((user) {
      if (user != null) {
        user.updateEmail("mehmet@mehmet.com").then((a) {
          setState(() {
            mesaj += "\Email güncellendi";
          });
        }).catchError((hata) {
          setState(() {
            mesaj += "\Email güncellenirken hata olustur $hata";
          });
        });
      } else {
        setState(() {
          mesaj += "\Email güncellemek için önce oturum açın";
        });
      }
    }).catchError((hata) {
      setState(() {
        mesaj += "\nKullanıcı getirilirken cıkan hata : $hata";
      });
    });
  }

  void _googleGiris() {
    _googleAuth.signIn().then((sonuc) {
      sonuc.authentication.then((googleKeys) {
        AuthCredential credential = GoogleAuthProvider.getCredential(
            idToken: googleKeys.idToken, accessToken: googleKeys.accessToken);
        _auth.signInWithCredential(credential).then((user) {
          setState(() {
            mesaj += "\nGmail ile giriş yapıldı";
          });
        }).catchError((hata) {
          setState(() {
            mesaj += "\nFirebase hatası";
          });
        });
      }).catchError((hata) {
        setState(() {
          mesaj += "\nGoogle auth hatası";
        });
      });
    }).catchError((hata) {
      setState(() {
        mesaj += "\nGoogle ile giriş yaparken hata oluştu";
      });
    });
  }

  void _telNoGiris() {
    String mail = "ciktieposta@mail.com.tr";
    String sifre = "123456";

    _auth.verifyPhoneNumber(
        phoneNumber: "+905555555555",
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) {
          _auth.signInWithCredential(credential).then((userAuthResult) {
            var user = userAuthResult.user;
            user.updateEmail(mail).then((aaa) {
              user.updatePassword(sifre).then((aaa) {
                debugPrint("Verification tamamlandı user: $user");
              });
            });
          });
        },
        verificationFailed: (AuthException exception) {
          debugPrint("Authexception ${exception.message}");
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          debugPrint("verification id: $verificationId");
          debugPrint("forceresending token: $forceResendingToken");

          AuthCredential credential = PhoneAuthProvider.getCredential(
              verificationId: verificationId, smsCode: "123456");
          _auth.signInWithCredential(credential).then((userAuthResult) {
            var user = userAuthResult.user;

            user.updateEmail(mail).then((aaa) {
              user.updatePassword(sifre).then((aaa) {
                debugPrint("Verification tamamlandı user: $user");
              });
            });
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          debugPrint("time out verification id: $verificationID");
        });
  }
}
