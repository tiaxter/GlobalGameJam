class Collectible{
  float absx;
  float absy;
  float mapx;
  float mapy;
  int collectible_type;
  boolean picked;
  PImage image;

  Collectible(float absx, float absy, float mapx, float mapy, int collectible_type, boolean picked){
    this.absx = absx;
    this.absy = absy;
    this.mapx = mapx;
    this.mapy = mapy;
    this.collectible_type = collectible_type;
    this.picked = picked;
    this.image = loadImage("letter.png");
  }

  @Override
  String toString(){
    return "Absolute X : " + absx + "\nAbsolute Y: " + absy +
    "\nMap X : " + mapx + "\nMap Y : " + mapy +
    "\nTipo di oggetto : " + collectible_type;
  }

  void resetStatus()
  {
    picked = false;
  }

  void draw(int camera_x, int camera_y)
  {
    //text("Obj: (" + this.absx + "," + this.absy + ") (" + mapx + "," + mapy + ")", this.absx - camera_x, this.absy - camera_y );
    if (!picked)
    {
      image(image, this.absx - camera_x, this.absy - camera_y);
    }
  }

  boolean isColliding(int player_x, int player_y)
  {
    return player_x == this.mapx && player_y == this.mapy;
  }

  boolean isCollidingBox(int player_xs, int player_xe, int player_ys, int player_ye)
  {
    //TODO: define note width rather than using palyer width
    return( player_xs < absx + Constants.TILE_W && 
            player_xe > absx &&
            player_ys < absy + Constants.TILE_H && 
            player_ye > absy);
  }


  void setPicked(boolean p)
  {
    this.picked = p;
  }

  String getText(int player)
  {
    switch(collectible_type)
    {
        case 274:
          if (player == Constants.JONNY)
            return "QUESTA STANZA E' RUMOROSA, CALDA, UMIDA\n"+
                   "E SECCA ALLO STESSO TEMPO... MA E' COSI'\n"+
                   "PICCOLA, MI FA SENTIRE BENISSIMO...\n"+
                   "MI RILASSA";
          else
            return "PERCHE' QUESTA STANZA E' COSÌ PICCOLA!?\n" +
                   "MI FA IMPAZZIRE, NON RIESCO A GIRARMI,\n" +
                   "NON RIESCO NEANCHE A PENSARE...\n" +
                   "VOGLIO ANDARMENE DA QUI!";

        case 275:
          if (player == Constants.JONNY)
            return  "LA CUCINA E' DOVE MAMMA E PAPA' CUCINANO\n"+
                    "E MANGIANO CON ME. DAL FORNO ESCONO\n" +
                    "BISCOTTI CALDI, LA MAMMA MI STRINGE\n" +
                    "E MI DA' TANTE COCCOLE MENTRE SIAMO\n" +
                    "SEDUTI A TAVOLA. MI FA SENTIRE AMATO.";
          else
            return  "QUESTO POSTO E' BRUTTO... IL FORNO BRUCIA,\n"+
                    "IL FRIGO E' FREDDO, MAMMA MI TIENE FERMO\n"+
                    "TRA LE BRACCIA, LA SEDIA E' SCOMODA...\n" +
                    "L’UNICA COSA BELLA E' LA FINESTRA DA CUI\n"+
                    "POSSO VEDERE IL CIELO. MI FA SENTIRE IN\n" +
                    "PERICOLO.";

        case 276:
          if (player == Constants.JONNY)
            return  "QUESTA E' LA STANZA CHE MI PIACE DI MENO...\n"+
                    "PERCHE' QUANDO SI VIENE QUI VUOL DIRE CHE\n" +
                    "CI SI VESTE PER USCIRE E A ME NON PIACE\n" +
                    "USCIRE... MI FA PAURA IL FUORI.";
        else
            return  "ODIO QUESTA CASA E QUESTI MURI... MA QUESTA\n" +
                    "LA ODIO MENO, PERCHE' QUANDO ANDIAMO QUI,\n" +
                    "VUOL DIRE CHE FINALMENTE SI ESCE!\n" +
                    "FINALMENTE SI RESPIRA...";

        case 287:
          if (player == Constants.JONNY)
            return  "QUESTO POSTO E'...OK.\n" +
                    "GUARDO LA TV CON PAPA',SEDUTO STRETTO\n" +
                    "A LUI SUL DIVANO OGNI DOMENICA,\n" +
                    "CI DIVERTIAMO TANTISSIMO PARLARE\n" +
                    "CON LUI, SOLO LE GRANDI VETRATE\n" +
                    "NON MI PIACCIONO...\n" +
                    "MI POSSONO GUARDARE\n" +
                    "DA FUORI.MI FA SENTIRE ESPOSTO...\n" +
                    "MA C'E' PAPA'";
        else
            return  "E'... OK.\n" +
                    "LA TV MI ANNOIA, PAPA' E' SUDATO\n" +
                    "E IL DIVANO E' STRETTO, NON MI FA RESPIRARE...\n" +
                    "E' SEMPRE COSI' APPICCICOSO. PERO'\n" +
                    "CI SONO LE VETRATE...MI PIACE PASSARE\n" +
                    "LE ORE A FISSARLE, OSSERVANDO IL CIELO,\n" +
                    "LE PIANTE, GLI ANIMALI, LE ATRE PERSONE...\n" +
                    "RIESCO A RESPIRARE.";

        case 288:
          if (player == Constants.JONNY)
            return  "MI DIVERTO SEMPRE TANTISSIMO QUI A GIOCARE\n" +
                    "CON PAPA'... NON SONO BRAVO QUANTO LUI,\n" +
                    "MA UN GIORNO SARO' PIU' BRAVO DI LUI A\n" +
                    "BILIARDO...PERCHE' USCIRE QUANDO TI\n" +
                    "DIVERTI COSI' TANTO DENTRO, SENZA\n" +
                    "PREOCCUPARTI DELLA PIOGGIA?";
          else
            return  "UN'ALTRA STANZA INUTILE...HAI TANTO SPAZIO\n" +
                    "PER GIOCARE FUORI, NON SERVE UN TETTO\n" +
                    "PER DIVERTIRSI, SOPRATTUTTO SE PIOVE...\n" +
                    "MI PIACE SENTIRE LA PIOGGIA\n" +
                    "ADDOSSO. SE QUESTO BILIARDO FOSSE\n" +
                    "ALL’APERTO MI\n" +
                    "PIACEREBBE DI PIÙ GIOCARCI.";
        default:
                    return "NON SO CHE DIRE.";
    }
  }

}
