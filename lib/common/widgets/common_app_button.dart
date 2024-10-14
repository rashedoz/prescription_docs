import 'package:flutter/material.dart';
import 'package:prescription_document/common/app_colors.dart';

class CommonAppButton extends StatelessWidget {
  final VoidCallback onTapButton;
  final String btnContent;
  final IconData btnIcon;
  const CommonAppButton({super.key,required this.onTapButton,required this.btnContent,required this.btnIcon});

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
        child:  Padding(padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 4),child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(btnIcon,color: Colors.white,size: 28,),
            // const Icon(Icons.cloud,color: Colors.white,size: 28,),
            const SizedBox(width: 8,),
            Text(btnContent,style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),)
          ],
        ),),
      ),
    );
  }
}