// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// Future<String> getUsername() async {
//   DocumentSnapshot snap = await FirebaseFirestore.instance
//       .collection('users')
//       .doc(FirebaseAuth.instance.currentUser!.uid)
//       .get();
//   var snapData = snap.data() as Map<String, dynamic>;

//   return snapData['username'];
// }

// Stream<DocumentSnapshot> getUsername() {
//   return FirebaseFirestore.instance
//       .collection('users')
//       .doc(FirebaseAuth.instance.currentUser!.uid)
//       .snapshots();
// }

 // ----- live update with streambuilder
      // appBar: AppBar(
      //   title: StreamBuilder(
      //     stream: getUsername(),
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.active) {
      //         if (snapshot.hasData) {
      //           var data = snapshot.data!.data() as Map;

      //           return Text(data['username']);
      //         } else if (snapshot.hasError) {
      //           return Text('Error: ${snapshot.error}');
      //         }
      //       }
      //       return CircularProgressIndicator();
      //     },
      //   ),
      // ),

  // -----

  // FutureBuilder(
  //           future: FirebaseFirestore.instance
  //               .collection('posts')
  //               .doc('4749d7b0-0647-1d6f-a054-958393a83d8c')
  //               .collection('testId')
  //               .doc('docId')
  //               .get(),
  //           builder: (context, snapshot) {
  //             if (snapshot.hasData) {
  //               print(snapshot.data!.data());
  //             }
  //             return Center(
  //               child: Text('hey'),
  //             );
  //           },
  //         ),
