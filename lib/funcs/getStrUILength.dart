double getStrUILength(String str,[double? other]) {
  double width = 0;
  for (int i = 0; i < str.length; i++) {
    if(str[i].codeUnitAt(0) >= 0x0041 && str[i].codeUnitAt(0) <= 0x007A ||
        str[i].codeUnitAt(0) >= 0x0041 && str[i].codeUnitAt(0) <= 0x005A || str[i].codeUnitAt(0) >= 0x0030 && str[i].codeUnitAt(0) <= 0x0039){
      width += 12;
    }else{
      width += 25;
    }
  }
  return width + (other ?? 0);
}
