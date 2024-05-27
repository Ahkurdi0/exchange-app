import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    required this.userId,
  });
  final String userId;

  @override
  Widget build(BuildContext context) {
    // Corrected to use the userId to fetch the correct document
    final Stream<DocumentSnapshot> _usersStream =
        FirebaseFirestore.instance.collection('users').doc(userId).snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: _usersStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // Updated logic to correctly handle the non-existence of a document
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;

        return Cards(
          data: data,
        );
      },
    );
  }
}

class Cards extends StatelessWidget {
  const Cards({
    super.key,
    required this.data,
  });

  final Map<String, dynamic> data; // Type hint for better code clarity

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 0, 38, 255),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('Operator'), Text('online')],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Colors.white,
            ),
            // child: Row(
            //   children: [
            //     // CardOne(
            //     //   color: Colors.green,
            //     //   heading: 'Credit',
            //     //   amount: '\$ ${data['totalCredit']}',
            //     // ),
            //     // SizedBox(
            //     //   width: 10,
            //     // ),
            //     // CardOne(
            //     //   color: Colors.red,
            //     //   heading: 'Debit',
            //     //   amount: '\$ ${data['totalDebit']}',
            //     // ),
            //   ],
            // ),
          ),
        ],
      ),
    );
  }
}

// class CardOne extends StatelessWidget {
//   const CardOne({
//     super.key,
//     required this.color,
//     required this.heading,
//     required this.amount,
//   });
//   final Color color;
//   final String heading;
//   final String amount;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Row(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     heading,
//                     style: TextStyle(color: color, fontSize: 14),
//                   ),
//                   Text(
//                     amount,
//                     style: TextStyle(
//                         color: color,
//                         fontSize: 30,
//                         fontWeight: FontWeight.w600),
//                   )
//                 ],
//               ),
//               Spacer(),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Icon(
//                   heading == 'Credit'
//                       ? Icons.arrow_downward_outlined
//                       : Icons.arrow_upward_outlined,
//                   color: color,
//                   size: 30,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
