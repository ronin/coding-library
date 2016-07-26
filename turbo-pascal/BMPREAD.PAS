Program Bitmap;
Uses
  Crt;

Type
  THandleBMP=record
  {nagˆ¢wek pliku}
    bfType:Word; {sygnatura pliku BMP: 4d42h ("BM")}
    bfSize:Longint; {Dˆugo˜† caˆego pliku}
    bfRes1:Word;  {zarezerwowane, pisa† 0}
    bfRes2:Word;  {zarezerwowane, pisa† 0}
    bfOffBits:Longint; {pozycja rysunku w pliku}
  {nagˆ¢wek mapy}
    biSize:Longint;  {dˆugo˜† nagˆ¢wka}
    biWidth:Longint; {szeroko˜† obrazka}
    biHeight:Longint; {wysoko˜† obrazka}
    biPlanes:Word;   {ilo˜† plan¢w, musi by† 1}
    biBitCount:Word; {ilo˜† bit¢w na piksel}
    biCompression:Longint; {Algorytm kompresji: 0=¾aden,  1,2=RLE}
    biSizeImage:Longint; {rozmiar obrazu}
    biXPelsPerMeter:Longint; {rozdzielczo˜† pozioma}
    biYPelsPerMeter:Longint; {rozdzielczo˜† pionowa}
    biClrUsed:Longint;       {liczba kolor¢w w palecie}
    biClrImportant:Longint;  {ilo˜† kolor¢w znacz¥cych, pisa† 0}
  End;

  tbufor=array[0..320*200-1] of byte; {bufor ekranu}

Var
  bufor:^tbufor;
  plikbmp:file; {uchwyt pliku bmp}
  bmphandle:THandleBMP; {nagˆ¢wek pliku BMP}
  paleta:array[0..4*256-1] of byte; {paleta kolor¢w}
  i:byte; {licznik p©tli}
  name:string; {nazwa pliku BMP}

procedure setvga;
begin
  asm
    mov ax, 13h
    int 10h
  end;
end;

procedure settxt;
begin
  asm
    mov ax, 03h
    int 10h
  end;
end;

begin
  write('Podaj nazw© pliku: '); Readln(name);
  assign(plikbmp,name);
  reset(plikbmp,1);
  {odczyt nagˆ¢wka}
    blockread(plikbmp,bmphandle,sizeof(bmphandle));
  {tryb graficzny}
    setvga;
  {odczyt palety}
    blockread(plikbmp,paleta,sizeof(paleta));
  {ustawienie palety}
    for i:=0 to 255 do begin
      port[$3c8]:=i;
      port[$3c9]:=paleta[i*4+2] div 4;
      port[$3c9]:=paleta[i*4+1] div 4;
      port[$3c9]:=paleta[i*4] div 4;
    end;
  {zarezerwowanie pami©ci dla bufora}
    new(bufor);
  {ustawienie jej w miejscu pami©ci karty graficznej}
    bufor:=ptr(sega000,0);
  {odczyt obrazka na ekran}
    blockread(plikbmp,bufor^,bmphandle.bisizeimage);
  {zamkni©cie pliku bmp}
    close(plikbmp);
  readkey;
  settxt;
end.