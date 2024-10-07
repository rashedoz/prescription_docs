import 'package:flutter/material.dart';
import 'package:prescription_document/common/app_colors.dart';

class CommonAppButton extends StatelessWidget {
  final VoidCallback onTapButton;
  const CommonAppButton({super.key,required this.onTapButton});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapButton,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(colors: [
            // AppColors.primaryColor.withOpacity(0.6),
            AppColors.primaryColor.withOpacity(0.7),
            // AppColors.primaryColor.withOpacity(0.9),
            AppColors.primaryColor
          ])
        ),
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 15,vertical: 4),child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_sharp,color: Colors.white,size: 28,),
            SizedBox(width: 8,),
            Text('Upload Prescription/Report',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),)
          ],
        ),),
      ),
    );
  }
}