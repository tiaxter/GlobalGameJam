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

  void draw(int camera_x, int camera_y)
  {
    if (!picked)
    {
      image(image, this.absx - camera_x, this.absy - camera_y);
    }
  }

  boolean isColliding(int player_x, int player_y)
  {
    return player_x == this.mapx && player_y == this.mapy; 
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
                    "GUARDO LA TV CON PAPA', SEDUTO STRETTO A LUI\n" +
                    "SUL DIVANO OGNI DOMENICA, CI DIVERTIAMO\n" +
                    "TANTISSIMO PARLARE CON LUI, SOLO LE GRANDI\n" +
                    "VETRATE NON MI PIACCIONO... MI POSSONO GUARDARE\n" +
                    "DA FUORI.MI FA SENTIRE ESPOSTO... MA C'E' PAPA'";
        else
            return  "E'... OK.\n" +
                    "LA TV MI ANNOIA, PAPA' E' SUDATO E IL DIVANO E'\n"+
                    "STRETTO, NON MI FA RESPIRARE... E' SEMPRE COSI'\n" +
                    "APPICCICOSO. PERO' CI SONO LE VETRATE...MI PIACE\n" +
                    "PASSARE LE ORE A FISSARLE, OSSERVANDO IL CIELO,\n" +
                    "LE PIANTE, GLI ANIMALI, LE ATRE PERSONE...\n" +
                    "RIESCO A RESPIRARE.";
        
        case 288:
          if (player == Constants.JONNY)
            return  "MI DIVERTO SEMPRE TANTISSIMO QUI A GIOCARE CON\n" +
                    "PAPA'... NON SONO BRAVO QUANTO LUI, MA UN GIORNO\n" +
                    "SARO' PIU' BRAVO DI LUI A BILIARDO...PERCHE'\n" +
                    "USCIRE QUANDO TI DIVERTI COSI' TANTO DENTRO, SENZA\n" +
                    "PREOCCUPARTI DELLA PIOGGIA?";
          else
            return  "UN'ALTRA STANZA INUTILE...HAI TANTO SPAZIO PER\n" +
                    "GIOCARE FUORI, NON SERVE UN TETTO PER DIVERTIRSI,\n" +
                    "SOPRATTUTTO SE PIOVE... MI PIACE SENTIRE LA PIOGGIA\n" +
                    "ADDOSSO. SE QUESTO BILIARDO FOSSE ALL’APERTO MI\n" +
                    "PIACEREBBE DI PIÙ GIOCARCI.";
        default:
                    return "NON SO CHE DIRE.";
    }
  }

}
