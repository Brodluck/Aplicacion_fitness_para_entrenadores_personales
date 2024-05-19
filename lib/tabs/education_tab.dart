import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ventanas/services/educational_service.dart';
import 'package:ventanas/models/educational_content.dart';
import 'package:provider/provider.dart';

class EducationTab extends StatelessWidget {
  const EducationTab({super.key});

  @override
  Widget build(BuildContext context) {
    final EducationalService educationalService = Provider.of<EducationalService>(context);

    return StreamBuilder<List<EducationalContent>>(
      stream: educationalService.getEducationalContent(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final contentList = snapshot.data!;
        return ListView.builder(
          itemCount: contentList.length,
          itemBuilder: (context, index) {
            final content = contentList[index];
            return ListTile(
              title: Text(content.title),
              subtitle: Text(content.description),
              onTap: () => _launchURL(content.url),
            );
          },
        );
      },
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
