unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Menus;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    ypedheure1: TMenuItem;
    TyHeure1: TMenuItem;
    TyHeure2: TMenuItem;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses  Math,       // on as toujours besoin des maths ;)
      DateUtils;  // et du temps...

type
  // type permettant de stocker un temps issus de GetTickCount
  TTickTime = record
    H,M,S,Cs,Ms : integer;
  end;

  // type permettant de stocker des degrés issus d'un temps
  TDegreTime = record
    H,M,S,Cs : extended;
  end;

Var
  TT    : TTickTime;      // Le temps par GetTickCount
  TD    : TDegreTime;     // Les degrés du temps sur un cadran

  CR,                     // coordonnées du centre de l'image
  NP    : TPoint;         // coordonnées de destination

  CBuf,                   // Buffer volatile de dessin pour Image1
  CPers : TBitmap;        // Buffer persistant pour CBuf

  Ray,                    // Rayon initial
  HRay,                   // Rayon de l'aiguille des heures
  MRay,                   // Rayon de l'aiguille des minutes
  SRay,                   // Rayon de l'aiguille des secondes
  CsRay,CsRay2 : integer; // Rayon et Demi-Rayon de "l'aiguille" des centiemes de secondes

const
   DegRad = pi/180;       // rapport Degrés > Radians pour Cos(Ø) et Sin(Ø) : Rad = Deg * (pi/180)
   GColor = $0088A288;    // couleur de fond
   EColor = $002C382C;    // couleur des elements
   HCOP   : array[0..23] of byte = (0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11);

procedure GetNow(out V : TTickTime);
var t : TTime;
begin
  // on recupere l'heures systeme courrante
  T    := Time;
  // on recupere les Centiemes de secondes
  V.Cs := MilliSecondOf(t) div 10;
  // on recupere les secondes
  V.S  := SecondOf(t);
  // on recupere les minutes
  V.M  := MinuteOf(t);
  // on recupere les heures
  V.H  := HCOP[HourOf(t)];
end;

procedure GetTick(out V : TTickTime);
var k : Cardinal;
begin
  // on recupere le temps ecoulé depuis le demarrage du PC
  k := GetTickCount;
  // on recupere les Centiemes de secondes
  V.Cs := (k mod 1000) div 10;
  // on recupere les secondes
  V.S  := (k div 1000) mod 60;
  // on recupere les minutes
  V.M  := (k div 60000) mod 60;
  // on recupere les heures
  V.H  := (k div 3600000);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var TDH : string;
begin
   // TICKTIME :: on choisis la methode que l'on veux, GetTick ou GetNow
      if TyHeure1.Checked then begin
         GetTick(TT);
         TDH := 'Windows tourne depuis';
      end else begin
         GetNow(TT);
         TDH := 'Il est';
      end;

      // affichage de TickTime super rapide grace a format
      label1.Caption := format('%s : %.2d:%.2d:%.2d.%.2d',[TDH,TT.H,TT.M,TT.S,TT.Cs]);

   // DEGRETIME  :: 1 cadran = 360°
      // K = 30 = Heure par cadran = 12/360
      TD.H  := ((TT.H*60)+TT.M)  * 0.5;
      // K = 6 = Minutes par cadran = 60/360
      TD.M  := TT.M  * 6  ;
      // K = 6 = Secondes par cadran = 60/360
      TD.S  := TT.S  * 6  ;
      // K = 3.6 = Centiemes de secondes par cadran = 100/360
      TD.Cs := TT.Cs * 3.6;

      // affichage de DegreTime grace a format ... rapide, simple, efficace
      label2.Caption := format('%.3d°, %.3d°, %.3d°, %.3d°',[round(TD.H),round(TD.M),round(TD.S),round(TD.Cs)]);

   // HORLOGE
      // creation de l'image "buffer" qui vas servir a dessiner l'horloge
      CBuf        := TBitmap.Create;
      CBuf.Width  := image1.width;
      CBuf.Height := image1.height;
      // Dessin de l'horloge
      with CBuf.Canvas do begin
           Brush.Color := GColor;
           Pen.Color   := EColor;

           // On recupere le fond a partir de l'image persistante
              Draw(0,0,CPers);

           // Heures
              Pen.Width   := 3;
              // On evite la repetition des calculs
              TD.H := (TD.H - 90) * DegRad;
              // calcul des point de destination de la ligne a tracer
              // on oublis pas de decaler de -90° pour correspondre au 0° d'un cadran
              NP.X := CR.X + round( HRay * Cos(TD.H) );
              NP.Y := CR.Y + round( HRay * Sin(TD.H) );
              MoveTo(CR.X,CR.Y);
              LineTo(NP.X,NP.Y);

           // Minutes
              Pen.Width := 2;
              TD.M := (TD.M - 90) * DegRad;
              NP.X := CR.X + round( MRay * Cos(TD.M) );
              NP.Y := CR.Y + round( MRay * Sin(TD.M) );
              MoveTo(CR.X,CR.Y);
              LineTo(NP.X,NP.Y);

           // Secondes
              Pen.Width := 1;
              TD.S := (TD.S - 90) * DegRad;
              NP.X := CR.X + round( SRay * Cos(TD.S) );
              NP.Y := CR.Y + round( SRay * Sin(TD.S) );
              MoveTo(CR.X,CR.Y);
              LineTo(NP.X,NP.Y);

           // Centiemes de seconde
              TD.Cs:= (TD.Cs - 90) * DegRad;
              NP.X := CR.X + round( CsRay * Cos(TD.Cs) );
              NP.Y := CR.Y + round( CsRay * Sin(TD.Cs) );
              Ellipse(NP.X-CsRay2, NP.Y-CsRay2, NP.X+CsRay2, NP.Y+CsRay2);
      end;
      // on assigne le buffer a l'image de destination
      Image1.Picture.Bitmap.Assign(CBuf);
      // on libere le buffer
      CBuf.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var N,X,Y : integer;
    T     : Extended;
    S     : String;
begin
  // on doublebufferise pour eviter le clignotement
     form1.DoubleBuffered  := true;
     panel1.DoubleBuffered := true;

  // on regle l'interval du timer pour correspondre a environ 25 FPS
     Timer1.Interval := round(1000/25);

  // juste pour eviter d'avoir des , dans l'affichage de DegreTime!
     DecimalSeparator     := '.';

  // on calcul tout de suite le centre de l'image
     CR  := point(Image1.width div 2, Image1.height div 2);

  // on calcul tout de suite le rayon de notre cadran
     Ray := Min(CR.X,CR.Y)-30;
  // et les autres rayons
     HRay   := Ray - 50;
     MRay   := Ray - 25;
     SRay   := Ray - 10;
     CsRay  := Ray - 6;
     CsRay2 := (Ray - CsRay) div 2;

  // Preparation de l'image persistante pour CBuf
     CPers := TBitmap.Create;
     CPers.Width := Image1.Width;
     CPers.Height:= Image1.Height;
     // Hop on dessine une bonne fois pour toute
     with CPers.Canvas do begin
       // Fond
          Brush.Color := GColor;
          Pen.Color   := GColor;
          Rectangle(0,0,Width,Height);

       Pen.Color := EColor;

       // Cadran
          // Cercle exterieur
             pen.Width := 2;
             Ellipse(CR.X-Ray-6, CR.Y-Ray-6, CR.X+Ray+6, CR.Y+Ray+6);

          // Graduation des heures et des minutes
             for N := 1 to 60 do begin
                 // M = 5 10 15 20 25 30 35 40 45 50 55 60
                 // H = 1  2  3  4  5  6  7  8  9 10 11 12
                 if N mod 5 = 0 then begin
                    pen.Width := 2;
                 end else begin
                    pen.Width := 1;
                 end;
                 T := ((N*6)-90)*DegRad;
                 X := CR.X + Round((Ray+5)*Cos(T));
                 Y := CR.Y + Round((Ray+5)*Sin(T));
                 MoveTo(CR.X, CR.Y);
                 LineTo(X, Y);
             end;

          pen.Width := 1;

          // Cercle interieur
             Ellipse(CR.X-Ray, CR.Y-Ray, CR.X+Ray, CR.Y+Ray);

          // Texte des graduations
             Font.Color := EColor;
             // verdana est l'une des rare police standard de windows a s'afficher correctement
             // meme avec une petite taille (7, 6)
             Font.Name  := 'Verdana';
             for N := 1 to 12 do begin
                 T := ((N*30)-90)*DegRad;

                 // Texte des heures
                    Font.Size := 8;
                    X := CR.X + Round((Ray+17)*Cos(T));
                    Y := CR.Y + Round((Ray+17)*Sin(T));
                    S := IntToStr(N);
                    // on oublis pas de centrer le texte sur la coordonnée pour eviter les decalages
                    TextOut(X-(TextWidth(S) div 2),Y-(TextHeight(S) div 2),S);

                 // Texte des minutes, secondes
                    Font.Size := 6;
                    X := CR.X + Round((Ray-12)*Cos(T));
                    Y := CR.Y + Round((Ray-12)*Sin(T));
                    // on convertis les heures en minutes en passant
                    S := IntToStr(round(N * (60/12)));
                    // on dis pas 11h60 mais Midi ... donc on remet a 0 ^.^
                    if S = '60' then S := '0';
                    TextOut(X-(TextWidth(S) div 2),Y-(TextHeight(S) div 2),S);
             end;
       end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Liberation de CPers
  CPers.Free;
end;

function BMPRotate (const BMPSrc: TBitmap;{ const xRotAxis, yRotAxis: integer;} const AngleRot: Extended ): TBitmap;
const
  MaxPixelCount = 32768;
type
  TRGBMatrix = array [0..32767] of TRGBTriple;
  pRGBMatrix = ^TRGBMatrix;
var
    CosT, SinT,
    Hyp               : extended;
    x, xSrc, xDest,
    y, ySrc, yDest,
    xRotAxis,yRotAxis : integer;
    RowSrc, RowDest   : pRGBMatrix;
begin
  xRotAxis := BMPSrc.Width div 2;
  yRotAxis := BMPSrc.Height div 2;

  Result := TBitmap.Create;
  with Result do begin
       Hyp         := sqrt(sqr(BMPSrc.Width)+sqr(BMPSrc.Height));
       SinCos(AngleRot,SinT,CosT);
       Width       := round(Hyp * CosT);
       Height      := round(Hyp * SinT);
       Pixelformat := pf24bit;
  end;
  sincos(AngleRot, SinT, CosT);
  for y := Result.Height-1 downto 0 do begin
      RowDest := Result.Scanline[y];
      yDest   := y - yRotAxis;
      for x := Result.Width-1 downto 0 do begin
          xDest := x - xRotAxis;
          xSrc  := xRotAxis + round(xDest * CosT - yDest * SinT);
          ySrc  := yRotAxis + round(xDest * SinT + yDest * CosT);
          if inrange(xSrc,0,BMPSrc.Width-1) and inrange(ySrc,0,BMPSrc.Height-1) then begin
             RowSrc     := BMPSrc.Scanline[ySrc];
             RowDest[x] := RowSrc[xSrc]
          end else begin
             RowDest[x].rgbtBlue  := 255;
             RowDest[x].rgbtGreen := 0;
             RowDest[x].rgbtRed   := 0
          end;
      end;
  end;
end;

end.
