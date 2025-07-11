// Widget articleCard(int blogId, String blogTitle, DateTime blogCreate, String blogImage, List<IconData> suggestionIcons) {
//   return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => BlogDetailScreen(blogId: blogId),
//           ),
//         );
//       },
//     child: Container(
//     width: 200,
//     margin: EdgeInsets.only(right: 16),
//     child: Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       elevation: 6,
//       shadowColor: Colors.black.withOpacity(0.2),
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Hình nhỏ lại, không bóp méo
//           ClipRRect(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             child: Container(
//               height: 100,
//               width: double.infinity,
//               color: Colors.green[50],
//               child: Center(
//                 child: Image.network(
//                   blogImage,
//                   height: 80,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   blogTitle,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15,
//                     color: Colors.green[800],
//                   ),
//                 ),
//                 SizedBox(height: 8),
//
//                 // Hàng icon gợi ý trái cây
//                 Row(
//                   children: suggestionIcons.map((iconData) {
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 8),
//                       child: FaIcon(
//                         iconData,
//                         size: 16,
//                         color: Colors.orange[700],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//
//                 SizedBox(height: 10),
//
//                 // Xem chi tiết
//                 Row(
//                   children: [
//                     FaIcon(FontAwesomeIcons.calendarDay, size: 14, color: Colors.green[700]),
//                     SizedBox(width: 6),
//                     Expanded(
//                       child: Text(
//                         DateFormat('dd/MM/yyyy').format(blogCreate),
//                         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     SizedBox(width: 3),
//                     Flexible(
//                       child: Text(
//                         'Xem chi tiết',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.green[700],
//                           fontWeight: FontWeight.w500,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
//   );
// }