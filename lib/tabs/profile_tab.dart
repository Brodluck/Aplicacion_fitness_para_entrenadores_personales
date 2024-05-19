// // import 'package:flutter/material.dart';

// // class ProfileTab extends StatelessWidget {
// //   const ProfileTab({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Center(
// //       child: Text('Personal Space'),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';

// class ProfileTab extends StatelessWidget {
//   const ProfileTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Sample user profile image URL
//     // String userProfileImageUrl = 'https://via.placeholder.com/150';

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Trainer App'),
//         actions: <Widget>[
//           InkWell(
//             onTap: () {
//               // Code to navigate to the Personal Tab or open the profile menu
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: CircleAvatar(
//                 backgroundImage: NetworkImage('https://via.placeholder.com/150'),
//               ),
//             ),
//           ),
//         ],
//       ),
//       // ... other widget components ...
//       body: const Center(
//         child: Text('Personal Space Content'),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:ventanas/services/progress_service.dart';
// import 'package:ventanas/models/progress.dart';
// import 'package:provider/provider.dart';

// class ProfileTab extends StatelessWidget {
//   final String userId; // Pass the userId as a parameter

//   const ProfileTab({super.key, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     final ProgressService progressService = Provider.of<ProgressService>(context);

//     return StreamBuilder<List<Progress>>(
//       stream: progressService.getAllProgress(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return const CircularProgressIndicator();
//         final progressList = snapshot.data!;
//         return ListView.builder(
//           itemCount: progressList.length,
//           itemBuilder: (context, index) {
//             final progress = progressList[index];
//             return ListTile(
//               title: Text('Weight: ${progress.weight} kg'),
//               subtitle: Text('Body Fat: ${progress.bodyFat}%'),
//               trailing: Text(progress.date.toString()),
//             );
//           },
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:ventanas/services/progress_service.dart';
import 'package:ventanas/models/progress.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  final String userId; // Pass the userId as a parameter

  const ProfileTab({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final ProgressService progressService = Provider.of<ProgressService>(context);

    return FutureBuilder<List<Progress>>(
      future: progressService.getAllProgress(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final progressList = snapshot.data!.where((progress) => progress.userId == userId).toList();
        return ListView.builder(
          itemCount: progressList.length,
          itemBuilder: (context, index) {
            final progress = progressList[index];
            return ListTile(
              title: Text('Weight: ${progress.weight} kg'),
              subtitle: Text('Body Fat: ${progress.bodyFat}%'),
              trailing: Text(progress.date.toString()),
            );
          },
        );
      },
    );
  }
}
