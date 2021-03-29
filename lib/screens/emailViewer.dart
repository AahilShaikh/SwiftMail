import 'package:flutter/material.dart';

class EmailViewer extends StatelessWidget{
  String content;
  String dateSent;
  String sender;
  String title;
  EmailViewer({Key key, @required this.content, @required this.dateSent, @required this.sender, @required this.title}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text('Title:')),
                Expanded(child: Text('$title')),
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(child: Text('Date Sent:')),
                Expanded(child: Text('$dateSent')),
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(child: Text('From:')),
                Expanded(child: Text('$sender')),
              ],
            ),
            Divider(),
            Wrap(
              children: [
                Text('$content'),
              ],
            ),
          ],
        ),
      ),
    );
  }

}