import 'package:flutter/material.dart';
//import './teacher_page/teacher_page.dart';

// At the top of teacher_page.dart
//library teacher_page;

//export 'teacher_page.dart';


class TeacherHomePage extends StatefulWidget {
  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  List<ClassInfo> classes = [];

  void _addClass(ClassInfo newClass) {
    setState(() {
      classes.add(newClass);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher\'s Classes'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: classes.isEmpty
          ? Center(
        child: Text(
          'No classes yet. Tap + to add a new class.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          return ClassCard(
            classInfo: classes[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassDetailPage(classInfo: classes[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddClassDialog();
        },
        child: Icon(Icons.add),
        tooltip: 'Add Class',
      ),
    );
  }

  void _showAddClassDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String className = '';
        String section = '';

        return AlertDialog(
          title: Text('Create a class'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: "Class name (required)"),
                onChanged: (value) {
                  className = value;
                },
              ),
              TextField(
                decoration: InputDecoration(hintText: "Section"),
                onChanged: (value) {
                  section = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Create'),
              onPressed: () {
                if (className.isNotEmpty) {
                  _addClass(ClassInfo(name: className, section: section));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class ClassCard extends StatelessWidget {
  final ClassInfo classInfo;
  final VoidCallback onTap;

  ClassCard({required this.classInfo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(classInfo.name[0]),
          backgroundColor: Colors.blue,
        ),
        title: Text(classInfo.name),
        subtitle: Text(classInfo.section),
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class ClassDetailPage extends StatelessWidget {
  final ClassInfo classInfo;

  ClassDetailPage({required this.classInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(classInfo.name),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue[100],
            child: Row(
              children: [
                CircleAvatar(
                  child: Text(classInfo.name[0]),
                  backgroundColor: Colors.blue,
                  radius: 30,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classInfo.name,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(classInfo.section),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Stream'),
                      Tab(text: 'Classwork'),
                      Tab(text: 'People'),
                    ],
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildStreamTab(),
                        _buildClassworkTab(),
                        _buildPeopleTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add functionality based on current tab
        },
        child: Icon(Icons.add),
        tooltip: 'Add new item',
      ),
    );
  }

  Widget _buildStreamTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildAnnouncementCard(
          'Welcome to the class!',
          'Hello everyone! I hope you\'re excited for this semester. Please review the syllabus and let me know if you have any questions.',
          'Posted 2 days ago',
        ),
        _buildAnnouncementCard(
          'Reminder: First quiz next week',
          'Don\'t forget, we have our first quiz next Tuesday. It will cover chapters 1-3 in the textbook.',
          'Posted yesterday',
        ),
      ],
    );
  }

  Widget _buildClassworkTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        AssignmentCard(title: 'Math Homework', dueDate: 'Due Tomorrow'),
        AssignmentCard(title: 'Science Project', dueDate: 'Due Next Week'),
        AssignmentCard(title: 'English Essay', dueDate: 'Due in 3 Days'),
        AssignmentCard(title: 'History Report', dueDate: 'Due in 5 Days'),
        AssignmentCard(title: 'Art Portfolio', dueDate: 'Due in 2 Weeks'),
      ],
    );
  }

  Widget _buildPeopleTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildPeopleSection('Teachers', [
          'Ms. Johnson (You)',
          'Mr. Smith (Co-teacher)',
        ]),
        Divider(),
        _buildPeopleSection('Students', [
          'Alice Anderson',
          'Bob Brown',
          'Charlie Chen',
          'Diana Davis',
          'Eva Evans',
          'Frank Foster',
          'Grace Green',
          'Henry Harris',
        ]),
      ],
    );
  }

  Widget _buildAnnouncementCard(String title, String content, String timestamp) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(content),
            SizedBox(height: 8),
            Text(
              timestamp,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(String title, String content, String dueDate) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assignment, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(content),
            SizedBox(height: 8),
            Text(
              dueDate,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeopleSection(String title, List<String> people) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        ...people.map((person) => Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              CircleAvatar(
                child: Text(person[0]),
                backgroundColor: Colors.blue[100],
              ),
              SizedBox(width: 8),
              Text(person),
            ],
          ),
        )),
      ],
    );
  }
}

class AssignmentCard extends StatelessWidget {
  final String title;
  final String dueDate;

  AssignmentCard({required this.title, required this.dueDate});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(Icons.assignment),
        title: Text(title),
        subtitle: Text(dueDate),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}

class ClassInfo {
  final String name;
  final String section;

  ClassInfo({required this.name, required this.section});
}