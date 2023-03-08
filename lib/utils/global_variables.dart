import 'package:autograph/screens/add_post_screen.dart';
import 'package:autograph/screens/feed_screen.dart';
import 'package:autograph/screens/profile_screen.dart';
import 'package:autograph/screens/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const webScreenSize =600;


List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notifications'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];