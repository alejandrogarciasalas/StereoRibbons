class Palette {
  
  color[] col;
  int schemeid = 1;
  
  Palette() {
    this.HotSteel();
  }
  
  void change() {
    schemeid = schemeid - 1;
    if (schemeid<0) {
      schemeid = 3;
    }
    if (schemeid==3) {
      this.HotSteel();
    } else if (schemeid==2) {
      this.GoodFriends();
    } else if (schemeid==1) {
      this.Firenze();
    } else if (schemeid==0) {
      this.OrangeGray();
    }
  }
  
  color get(int id) {
    id = id % this.col.length;
    id = min(max(0,id),this.col.length-1);
    return this.col[id];
  }
  color get() {
    int id = round(random(0,this.col.length-1));
    return this.col[id];
  }
  
  color _addalpha(color c, float a) {
    return color(red(c),green(c),blue(c),a);
  }
  
  color get_transp(int id, float a) {
    id = min(this.col.length-1,id % this.col.length);
    id = max(id,0);
    return this._addalpha(this.col[id],a);
  }
  color get_transp(float a) {
    int id = round(random(0,this.col.length-1));
    return this._addalpha(this.col[id],a);
  }
  
  void GoodFriends() {
    //http://www.colourlovers.com/palette/77121/Good_Friends
    this.col = new color[5];
    int id=0;
    this.col[id++] = color(217,206,178);
    this.col[id++] = color(148,140,117);
    this.col[id++] = color(213,222,217);
    this.col[id++] = color(122,106,83);
    this.col[id++] = color(153,178,183);
  }

  void HotSteel() {
    //http://www.colourlovers.com/palette/77121/Good_Friends
    this.col = new color[5];
    int id=0;
    this.col[id++] = color(242,181,68);
    this.col[id++] = color(242,138,46);
    this.col[id++] = color(242,84,27);
    this.col[id++] = color(89,9,2);
    this.col[id++] = color(191,32,17);
  }


  void APalette() {
    //http://www.colourlovers.com/palette/903157/Entrapped_InAPalette
    this.col = new color[5];
    int id=0;
    this.col[id++] = color(185,215,217);
    this.col[id++] = color(102,130,132);
    this.col[id++] = color(42,40,41);
    this.col[id++] = color(73,55,54);
    this.col[id++] = color(123,59,59);
  }
 
  void FlashingNeon() {
    //https://kuler.adobe.com/Flashing-Neon-color-theme-118695/edit/?copy=true
    this.col = new color[5];
    int id=0;
    this.col[id++] = color(153,5,0);
    this.col[id++] = color(204,6,0);
    this.col[id++] = color(255,0,227);
    this.col[id++] = color(159,255,0);
    this.col[id++] = color(198,204,0);
  }
  
  void HotLove() {
    this.col = new color[5];
    int id=0;
    this.col[id++] = color(89,2,34);
    this.col[id++] = color(242,29,129);
    this.col[id++] = color(166,31,94);
    this.col[id++] = color(217,30,133);
    this.col[id++] = color(242,208,240);
  }
  
  void MetalOrange() {
    this.col = new color[5];
    int id=0;
    this.col[id++] = color(235,100,0);
    this.col[id++] = color(245,73,0);
    this.col[id++] = color(222,38,0);
    this.col[id++] = color(46,32,29);
    this.col[id++] = color(74,55,47);
  }
    
  void Cake() {
    //http://www.colourlovers.com/palette/49963/let_them_eat_cake
    this.col = new color[5];
    int id=0;
    this.col[id++] = color(119,79,56);
    this.col[id++] = color(224,142,121);
    this.col[id++] = color(241,212,175);
    this.col[id++] = color(236,229,206);
    this.col[id++] = color(197,224,200);
  }
  
  void Firenze() {
    this.col = new color[5];
    int id=0;
    this.col[id++] = color(70,137,102);
    this.col[id++] = color(255,240,165);
    this.col[id++] = color(255,176,59);
    this.col[id++] = color(182,73,38);
    this.col[id++] = color(142,40,0);
  }
  

  void OrangeGray() {
    this.col = new color[5];
    int id=0;
    this.col[id++] = color(255,248,227);
    this.col[id++] = color(204,204,159);
    this.col[id++] = color(51,51,45);
    this.col[id++] = color(159,180,204);
    this.col[id++] = color(219,65,5);
  }
  
}
