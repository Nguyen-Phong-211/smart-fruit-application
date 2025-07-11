import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class BlogModel {
  final int blogId;
  final String blogTitle;
  final DateTime blogCreate;
  final String blogContent;
  final String blogImage;

  BlogModel
      ({
        required this.blogId,
        required this.blogTitle,
        required this.blogImage,
        required this.blogCreate,
        required this.blogContent,
      });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      blogId: json['blog_id'],
      blogTitle: json['title'],
      blogCreate: DateTime.parse(json['created_at']),
      blogContent: json['content'],
      blogImage: json['image'],
    );
  }
}

class BlogDetailModel {
  final int id;
  final String title;
  final String slug;
  final String type;
  final int view;
  final String content;
  final String imageUrl;
  final String status ;
  final String metaTitle;
  final String metaDescription;
  final DateTime createdAt;

  BlogDetailModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.type,
    required this.view,
    required this.content,
    required this.imageUrl,
    required this.status,
    required this.metaTitle,
    required this.metaDescription,
    required this.createdAt,
  });

  factory BlogDetailModel.fromJson(Map<String, dynamic> json) {
    return BlogDetailModel(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      type: json['type'],
      view: json['view'],
      content: json['content'],
      imageUrl: json['image_url'],
      status: json['status'],
      metaTitle: json['meta_title'],
      metaDescription: json['meta_description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

