unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids,math,ComObj,Diagnostics,psAPI;

type
   W=array[1..20]of integer;
   Rname=string[7];
    Rect=record
        Xmin,Xmax,Ymin,Ymax,cuckoo:int64;
        R_Name:Rname;
        flage,priorty,sps,spe,dps,dpe:integer;
    end;
    PTreeEntry = ^TTreeEntry;
    TTreeEntry = record
      Child:array[1..5]of PTreeEntry;
      Parent:PTreeEntry;
      Data: array[1..5]of Rect;
      ChildCounter,Count,i,j: Integer;

    end;
    Rule=record
       Pri,Ingr,Meta_data,Vlan_ID,Vlan_priority,MPLS_Lable,MPLS_tfc,X_range,Y_range,ToS,SP,DP,flag,
       Eth_src,Eth_dst,Eth_type  , SA,DA, Prtl:string;
    end;
    res=record
        flage,priorty,sps,spe,dps,dpe:integer ;
         cuckoo:int64 ;
     end;

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    sg1: TStringGrid;
    Button4: TButton;
    Edit2: TEdit;
    Edit3: TEdit;
    Button3: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit4: TEdit;
    ComboBox3: TComboBox;
    Edit5: TEdit;
    ComboBox4: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label1: TLabel;
    ComboBox5: TComboBox;
    Label2: TLabel;
    Edit6: TEdit;
    Label8: TLabel;
    Edit7: TEdit;
    Edit11: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Edit15: TEdit;
    Edit16: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    Edit17: TEdit;
    Edit18: TEdit;
    ComboBox6: TComboBox;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Button5: TButton;
    Edit8: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    OD1: TOpenDialog;
    Label18: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure insert(x1,x2,y1,y2:int64;R:Rname;var T:PTreeEntry);
    procedure SortInsert( x1,x2,y1,y2:int64;R:Rname;var T:PTreeEntry);

    procedure DiveInsert( x1,x2,y1,y2:int64;R:Rname;var T:PTreeEntry);
    procedure InChildInsert( x1,x2,y1,y2:int64;g:w;R:Rname;var T:PTreeEntry);
    procedure ChildDiveInsert( x1,x2,y1,y2:int64;g:w;R:Rname;var T:PTreeEntry);
    procedure ReSort(var g:integer; var T:PTreeEntry);
    function min(x,y:int64):int64;
    function max(x,y:int64):int64;
    procedure FormCreate(Sender: TObject);
     procedure Xrange(s:string;var x1,x2:integer);
     procedure Xrange1(s:string;var x1,x2:int64 );
     procedure ParentInsert(x1,x2,y1,y2:int64;g:W;R:Rname;var T:PTreeEntry);
     procedure draw ( T:PTreeEntry;l:integer);
      procedure draw1 ( T:PTreeEntry;l:integer);
     procedure zero( T:PTreeEntry);
     procedure DividParent(var T:PTreeEntry;g:w);
     procedure InChildFInsert( x1,x2,y1,y2:int64;var kk:w;R:Rname;var T:PTreeEntry);
     procedure ReParent( var T:PTreeEntry);
    procedure Button4Click(Sender: TObject);
    procedure search(X,Y:int64; T:PTreeEntry);
    Procedure closest( x1,x2,y1,y2:int64; var K:integer;var T:PTreeEntry  );
    procedure CRC( s:string;var index1,index2:int64);
     procedure flage_cuckoo(var rest:res);
    // procedure muchinsert(var rn:integer);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Form1: TForm1;
   Tree, P: PTreeEntry;
   Rules:array[1..10000]of rule;
   Excel:Variant ;
   rulescount,rn,cf1,cf2,cf3,cf4:integer;
   kk,ll:integer;
    Rl:rule;
    rest:res;
    f:boolean;
    c1,c2,c4,c3,cc1,cc2,ff:int64;
implementation

{$R *.DFM}

//Procedure muchinsert(var rn:integer);
      // begin

      //   RN:=strtoint(form1.edit8.text);
      //   form1.Label16.Visible:=false;
      //   form1.Edit8.Visible:=false;
      // end;


procedure TForm1.flage_cuckoo(var rest:res);
var m,i,n,c:integer;
     s1,s2:string;   index1,index2:int64;
   
     b:array[1..64]of integer;
begin
rest.flage:=0;
         for i:=1 to 64 do
            b[i]:=0;
         rl.Pri:=Excel.ActiveSheet.Cells[rulescount,2].Value;
          rest.priorty:= strtoint(rl.Pri);
         m:=1;
       rl.Pri:=Excel.ActiveSheet.Cells[rulescount,2].Value;

       rl.Ingr:=Excel.ActiveSheet.Cells[rulescount,3].Value;
       if rl.Ingr ='*' then
          rest.flage:=rest.flage+m
       else begin
              CRC('in'+rl.ingr,index1,index2);b[index1]:=1;b[index2]:=1;
              end;
        m:=m*2;

       rl.Meta_data:=Excel.ActiveSheet.Cells[rulescount,4].Value ;
       if rl.Meta_data ='*' then
          rest.flage:=rest.flage+m
       else begin CRC('md'+rl.Meta_data ,index1,index2);b[index1]:=1;b[index2]:=1;end; m:=m*2;

       rl.Eth_src:=Excel.ActiveSheet.Cells[rulescount,5].Value;
       if rl.Eth_src ='FF-FF-FF-FF-FF-FF' then rest.flage:=rest.flage+m
        else begin CRC(rl.Eth_src,index1,index2);b[index1]:=1;b[index2]:=1; end;     m:=m*2;
       rl.Eth_dst:=Excel.ActiveSheet.Cells[rulescount,6].Value;  if rl.Eth_dst ='FF-FF-FF-FF-FF-FF' then rest.flage:=rest.flage+m
       else begin CRC(rl.Eth_dst,index1,index2);b[index1]:=1;b[index2]:=1;end; m:=m*2;

       rl.Eth_type :=Excel.ActiveSheet.Cells[rulescount,7].Value ;  if rl.Eth_type ='*' then rest.flage:=rest.flage+m
       else begin CRC('et'+rl.Eth_type,index1,index2);b[index1]:=1;b[index2]:=1;end;  m:=m*2;

       rl.Vlan_ID :=Excel.ActiveSheet.Cells[rulescount,8].Value;  if rl.Vlan_ID ='*' then rest.flage:=rest.flage+m
       else begin CRC('vi'+rl.Vlan_ID,index1,index2);b[index1]:=1;b[index2]:=1;end;   m:=m*2;

       rl.Vlan_priority :=Excel.ActiveSheet.Cells[rulescount,9].Value; if rl.Vlan_priority ='*' then rest.flage:=rest.flage+m
       else begin CRC('vp'+rl.Vlan_priority,index1,index2);b[index1]:=1;b[index2]:=1; end;  m:=m*2;

       rl.MPLS_Lable:=Excel.ActiveSheet.Cells[rulescount,10].Value; if rl.MPLS_Lable ='*' then rest.flage:=rest.flage+m
       else begin CRC('ml'+rl.MPLS_Lable,index1,index2);b[index1]:=1;b[index2]:=1;end;   m:=m*2;

       rl.MPLS_tfc:=Excel.ActiveSheet.Cells[rulescount,11].Value;  if rl.MPLS_tfc ='*' then rest.flage:=rest.flage+m
       else begin CRC('mt'+rl.MPLS_tfc,index1,index2);b[index1]:=1;b[index2]:=1;end;  m:=m*2;

       rl.Prtl:=Excel.ActiveSheet.Cells[rulescount,14].Value;   if rl.Prtl ='*' then rest.flage:=rest.flage+m
       else begin CRC('Pr'+rl.Prtl,index1,index2);b[index1]:=1;b[index2]:=1; end;  m:=m*2;

       rl.ToS :=Excel.ActiveSheet.Cells[rulescount,15].Value;  if rl.ToS ='*' then rest.flage:=rest.flage+m
       else begin CRC('tos'+rl.ToS,index1,index2);b[index1]:=1;b[index2]:=1;end; m:=m*2;
       rl.SP:=Excel.ActiveSheet.Cells[rulescount,16].Value;
       s1:='';i:=1;
       while rl.sp[i]<>':'do
        begin s1:=s1+rl.sp[i]; i:=i+1; end;
       s2:='';i:=i+1;
       while i<=length(rl.sp)do
        begin s2:=s2+rl.sp[i]; i:=i+1; end;
        if s1<>s2 then  rest.flage:=rest.flage+m else if not ((s1='0')and (s2='65535')) then begin CRC('sp'+s1,index1,index2);b[index1]:=1;b[index2]:=1; end; m:=m*2;
        if (s1='0')and (s2='65535') then   rest.flage:=rest.flage+m; m:=m*2;
       rl.DP:=Excel.ActiveSheet.Cells[rulescount,17].Value;
       rest.sps:=strtoint(s1);
       rest.spe:=strtoint(s2);
         s1:='';i:=1;
       while rl.DP[i]<>':'do
        begin s1:=s1+rl.DP[i]; i:=i+1; end;
       s2:='';i:=i+1;
       while i<=length(rl.DP)do
        begin s2:=s2+rl.DP[i]; i:=i+1; end;
        if s1<>s2 then  rest.flage:=rest.flage+m else if not ((s1='0')and (s2='65535')) then begin CRC('dp'+s1,index1,index2);b[index1]:=1;b[index2]:=1; end; m:=m*2;
        if (s1='0')and (s2='65535') then   rest.flage:=rest.flage+m; m:=m*2;
        rest.dps:=strtoint(s1);
        rest.dpe:=strtoint(s2);
        rest.cuckoo:=0;
        c:=1;
       for i:= 1 to 64 do
          begin
            if b[i]=1 then
               rest.cuckoo:=rest.cuckoo+c;
            c:=c*2;
          end;

end;
procedure TForm1.CRC( s:string;var index1,index2:int64);
     var  x1,x2,x0,x3,x4,x5,x6,j,x7,v,c,i:integer;
        ss:string;
    begin

     for  i:= 1 to length(s)do
      begin
         c:=ord(s[i]);
         for j:=1 to 8 do
            begin
               ss:=ss+inttostr(c mod 2);
               c:=c div 2;
            end;
       end;


       x7:=1;x6:=1;x5:=1;x4:=1;x3:=1;x2:=1;x1:=0;x0:=0;
       for i:= 1 to length(ss) do
                        begin
                          v :=strtoint(ss[i]);
                          x7:=x6 xor v;
                          x6:=x5 xor v;
                          x5:=x4;
                          x4:=x3 xor v;
                          x3:=x2;
                          x2:=x1 xor v;
                          x1:=x0;
                          x0:=x7 xor v ;

                        end;

    index1:=x7*1+x6*32+x5*4+x4*8+x3*16+1+x2*2;
    index2:=x0*16+x1*8+x2*32+x3*2+x4*1+1+x7*4;

     end;
procedure swab(var x,y:int64);
    var
       T:int64;
    begin
      t:=x;
      x:=y;
      y:=t;
    end;
procedure TForm1.ReParent( var T:PTreeEntry);
   var i:integer;

   begin

     for i:= 1 to T^.ChildCounter do
     if T^.Child[i]<> nil then
        begin
          if T^.Data[i].Xmin>T^.Data[i].Xmax then
             swab( T^.Data[i].Xmin,T^.Data[i].Xmax);
          if T^.Data[i].ymin>T^.Data[i].ymax then
             swab( T^.Data[i].ymin,T^.Data[i].ymax);


          T^.Child[i]^.Parent:=T;
          if T^.Child[i]^.ChildCounter >0 then
             begin
               T^.Child[i]^.Data[1].R_Name:='R*';
               T^.Child[i]^.Data[2].R_Name:='R*';
               T^.Child[i]^.Data[3].R_Name:='R*';
               T^.Child[i]^.Data[4].R_Name:='R*';
             end;
          ReParent(T^.Child[i]);
        end;
   end;
procedure Tform1.DividParent(var T:PTreeEntry;g:w);
   var
      i:integer; k:rect;
      C1,C2: PTreeEntry ;f:boolean;
   begin
     new(C1);
     Zero(C1);
     New(C2);
     Zero(C2);
      f:=false;
      C1^.Data[1]:=T^.Data[1] ; C1^.Data[2]:=T^.Data[2];C1^.Data[3]:=T^.Data[3];
     C1^.Child[1]:=T^.Child[1] ;C1^.Child[2]:=T^.Child[2]; C1^.Child[3]:=T^.Child[3];

     C1^.Count:=3;C1^.ChildCounter:=3;

     C2^.Data[1]:=T^.Data[4] ; C2^.Data[2]:=T^.Data[5];
     C2^.Child[1]:=T^.Child[4] ;C2^.Child[2]:=T^.Child[5];

     C2^.Count:=2;C2^.ChildCounter:=2;

     if T^.Parent =nil then
       begin
         T^.Data[1].Xmin:=min(min(C1^.Data[1].Xmin,C1^.Data[2].Xmin),C1^.Data[3].Xmin);
         T^.Data[1].Xmax:=max(max(C1^.Data[1].Xmax,C1^.Data[2].Xmax),C1^.Data[3].Xmax);
         T^.Data[2].Xmin:=min(C2^.Data[1].Xmin,C2^.Data[2].Xmin);
         T^.Data[2].Xmax:=max(C2^.Data[1].Xmax,C2^.Data[2].Xmax);
         T^.Data[1].Ymin:=min(min(C1^.Data[1].Ymin,C1^.Data[2].Ymin),C1^.Data[3].Ymin);
         T^.Data[1].Ymax:=max(max(C1^.Data[1].Ymax,C1^.Data[2].Ymax),C1^.Data[3].Ymax);
         T^.Data[2].Ymin:=min(C2^.Data[1].Ymin,C2^.Data[2].Ymin);
         T^.Data[2].Ymax:=max(C2^.Data[1].Ymax,C2^.Data[2].Ymax);
         T^.Data[1].R_Name:='R*';
         T^.Data[2].R_Name:='R*';

         T^.Child[1]:=C1;
         T^.Child[2]:=C2;
         T^.Count:=2;
         T^.ChildCounter:=2;
         C1^.Parent:=T;
         C2^.Parent :=T;
         T^.Child[3]:=nil;
         T^.Child[4]:=nil;
         T^.Child [5]:=nil;
        end    ////ok
      else
          begin
             if T^.Parent^.Count >= 4 then
               F:=true;
            T^.Parent^.Child[T^.Parent^.ChildCounter+1]:=C2;
            T^.Parent^.Data[g[g[20]]].Xmin:=min(min(C1^.Data[1].Xmin,C1^.Data[2].Xmin),C1^.Data[3].Xmin);
            T^.Parent^.Data[g[g[20]]].Xmax:=max(max(C1^.Data[1].Xmax,C1^.Data[2].Xmax),C1^.Data[3].Xmax);
            T^.Parent^.Data[T^.Parent^.ChildCounter+1].Xmin:=min(C2^.Data[1].Xmin,C2^.Data[2].Xmin);
            T^.Parent^.Data[T^.Parent^.ChildCounter+1].Xmax:=max(C2^.Data[1].Xmax,C2^.Data[2].Xmax);

            T^.Parent^.Data[g[g[20]]].Ymin:=min(min(C1^.Data[1].Ymin,C1^.Data[2].Ymin),C1^.Data[3].Ymin);
            T^.Parent^.Data[g[g[20]]].Ymax:=max(max(C1^.Data[1].Ymax,C1^.Data[2].Ymax),C1^.Data[3].Ymax);
            T^.Parent^.Data[T^.Parent^.ChildCounter+1].Ymin:=min(C2^.Data[1].Ymin,C2^.Data[2].Ymin);
            T^.Parent^.Data[T^.Parent^.ChildCounter+1].Ymax:=max(C2^.Data[1].Ymax,C2^.Data[2].Ymax);




            T^.Data[g[g[20]]].R_Name:='R*';
            T^.Data[T^.Parent^.ChildCounter+1].R_Name:='R*';
          //  ReSort(g,T^.Parent);
            T^.Parent^.Count:=T^.Parent^.Count+1;
            T^.Parent^.ChildCounter:=T^.Parent^.ChildCounter+1;
            C1^.Parent:=T^.Parent;
            C2^.Parent :=T^.Parent ;
          //  T^.Child[3]:=nil;
            T^.Child[4]:=nil;
            T^.Child [5]:=nil;
            T^.ChildCounter :=3;
            T^.Count :=3;
            T:=C1;
          end; //ReParent(T);
           if F then
             begin
                 kk:=kk+1;
                 if kk>2 then
                 kk:=i;
               g[20]:=g[20]-1;
              DividParent(T^.Parent,g );
             end;

     //ReParent(T);

    end;
procedure TForm1.zero( T:PTreeEntry);
   var i:integer;
   begin
      for i:=1 to 5 do
         begin
            T^.Child[i]:=nil;
            T^.Data[i].Xmin:=-1;
            T^.Data[i].Xmax:=-1;
            T^.data[i].R_Name :='';
            T^.Data[i].Ymin:=-1;
            T^.Data[i].Xmax :=-1;
        //    T^.Child[i].Parent :=T;
          end;
            T^.ChildCounter :=0;
            T^.Count :=0;
            T^.Parent :=nil;
   end;
procedure TForm1.ParentInsert(x1,x2,y1,y2:int64;g:w;R:Rname;var T:PTreeEntry);

      var   i:integer; k:rect;
       C1,C2,q: PTreeEntry ;
    begin
             SortInsert(x1,x2,y1,y2,R,T);
             t^.Data:=t^.Data ;
             new(q);
             zero(q);
             q^.Data[1]:=T^.Data[4];
             q^.Data[2]:=T^.Data[5];
             T^.Data[4].Xmin :=-1;T^.Data[4].Xmax:=-1;
             T^.Data[5].Xmin :=-1;T^.Data[5].Xmax:=-1;
              T^.Count :=3;
              Q^.Count :=2;
              Q^.Parent :=T^.Parent ;
              T^.Parent^.Child[5]:=q;
              T^.Parent^.Count :=5;
              T^.Parent^.Data[5].Xmin:=min(Q^.Data[1].Xmin,Q^.Data[2].Xmin);
              T^.Parent^.Data[5].Xmax:=max(Q^.Data[1].Xmax,Q^.Data[2].Xmax);
              T^.Parent^.Data[5].Ymin:=min(Q^.Data[1].Ymin,Q^.Data[2].Ymin);
              T^.Parent^.Data[5].Ymax:=max(Q^.Data[1].Ymax,Q^.Data[2].Ymax);

               T^.Parent^.Data[g[g[20]]].Xmin:=min(min(t^.Data[1].Xmin,t^.Data[2].Xmin),t^.Data[3].Xmin);
              T^.Parent^.Data[g[g[20]]].Xmax:=max(max(t^.Data[1].Xmax,t^.Data[2].Xmax),t^.Data[3].Xmax);
              T^.Parent^.Data[g[g[20]]].Ymin:=min(min(t^.Data[1].Ymin,t^.Data[2].Ymin),t^.Data[3].ymin);
              T^.Parent^.Data[g[g[20]]].Ymax:=max(max(t^.Data[1].Ymax,t^.Data[2].Ymax),t^.Data[2].ymax);

              T^.Parent^.Data[5].R_Name :='R*';
             // resort(g,T^.parent);
              //ReParent(T);
              //g[20]:=1;
              g[20]:=g[20]-1;
              DividParent(T^.Parent,g);             //**************//
             // ReParent(T);


     end;
procedure TForm1.Xrange(s:string;var x1,x2:integer);
  var i,m,n:integer;
  begin
    m:=0 ;
    n:=128;
    x1:=0;x2:=0;
    for i:=1 to 8 do
       begin
          if s[i]='1' then
            begin
              m:=m+n;
              x1:=m;
              x2:=m;
            end
          else if s[i]<>'0' then
                 begin m:=m+n;
                       x2:=m;
                 end;
        n:=n div 2;
      end;


  end;
procedure pow(x,y:integer;var n:int64);
      var
         i:integer;

      begin
        n:=1;
        for i:= 1 to y do
           n:=n*x;

      end;
procedure TForm1.Xrange1(s:string;var x1,x2:int64);
    var i,j,m:integer;
      d,ff:string[4];
      s1,s2:string[32];
      n,k:int64;
      f:boolean;
    begin
       i:=0;
       d:='';
       m:=256*256*256;
       n:=0;
       ff:='';
       f:=false;
       s2:='';
       while i< length(s) do
         begin  i:=i+1;
           if f then
              ff:=ff+s[i];

            if (s[i]<> '.') and (s[i]<>'/') then
               d:=d+s[i]
            else
               begin

                 k:=(strtoint(d));
                   s1:='';   d:='';
                  for j:=1 to 8 do
                    begin
                      s1:=inttostr(k mod 2 )+s1;
                      k:=k div 2;
                    end;
                     s2:=s2+s1;

               end;
            if s[i]='/' then
              f:=true;

         end;
         s:='';

           pow(2,31,n);
            k:=strtoint(ff);
       x1:=0;
       x2:=0;
     for i:= 1 to 32 do
        begin
          if i<=k then
            begin
              if s2[i]='1' then
                begin
                  x1:=x1+n;
                  x2:=x2+n;
                end;
             end
           else
              x2:=x2+n;
           n:=n div 2

         end;
  end;
function TForm1.min(x,y:int64):int64;
  begin

  if x<y then
      result:=x
  else
  result:=y;
  end;
function TForm1.max(x,y:int64):int64;
      begin
     if x<y then
      result:=y
     else
     result:=x;
  end;
procedure TForm1.draw1 ( T:PTreeEntry;l:integer);
   begin
   // ReParent(T);
       form1.Canvas.Rectangle(00,00,2000,800 );
     draw(T,l);
   end;
procedure Tform1.draw ( T:PTreeEntry;l:integer);
var k,p1,p2,p3,p4:integer;
   begin

      if T<>nil then
         begin

           for k:=1 to 5  do
           if k<=T^.Count  then
            begin
               if K<=1 then
                  form1.Canvas.TextOut(T^.i+50*(k-1),T^.j,T^.Data[k].R_Name+'=X('+inttostr(T^.data[k].xmin)+'_'+inttostr(T^.data[k].xmax)+'), Y('+inttostr(T^.data[k].Ymin)+'_'+inttostr(T^.data[k].Ymax)+')')
               else if K<=2 then form1.Canvas.TextOut(T^.i+50*(k-2),T^.j+15,T^.Data[k].R_Name+'=X('+inttostr(T^.data[k].xmin)+'_'+inttostr(T^.data[k].xmax)+'), Y('+inttostr(T^.data[k].Ymin)+'_'+inttostr(T^.data[k].Ymax)+')')
               else  if K<=3 then form1.Canvas.TextOut(T^.i+50*(k-3),T^.j+30,T^.Data[k].R_Name+'=X('+inttostr(T^.data[k].xmin)+'_'+inttostr(T^.data[k].xmax)+'), Y('+inttostr(T^.data[k].Ymin)+'_'+inttostr(T^.data[k].Ymax)+')')
                  else   form1.Canvas.TextOut(T^.i+50*(k-4),T^.j+45,T^.Data[k].R_Name+'=X('+inttostr(T^.data[k].xmin)+'_'+inttostr(T^.data[k].xmax)+'), Y('+inttostr(T^.data[k].Ymin)+'_'+inttostr(T^.data[k].Ymax)+')');
            end ;

             if T^.ChildCounter >0 then
               if T^.ChildCounter =2 then
                   begin P1:=-550;P2:=550;end
                   else if T^.ChildCounter =3 then
                          begin P1:=-500;P2:=0; P3:=500;end
                         else begin P1:=-500;P2:=-200;P3:=200;P4:=500 end;


           if T^.child[1]<>nil then begin T^.child[1]^.i:=T^.i +P1 div Ceil  (3* l / T^.ChildCounter)    ; T^.child[1]^.j:=T^.j +70 ;form1.Canvas.MoveTo(T^.i+20,T^.j+15);  form1.Canvas.LineTo (T^.child[1]^.i,T^.child[1]^.j);draw(T^.child[1],l*2);end;
           if T^.Child[2]<>nil then begin T^.Child[2]^.i:=T^.i +P2 div Ceil(3*l /  T^.ChildCounter) ; T^.Child[2]^.j:=T^.j +70 ;form1.Canvas.MoveTo(T^.i+20,T^.j+15);form1.Canvas.LineTo (T^.Child[2]^.i,T^.Child[2]^.j);draw(T^.Child[2],l*2);end;
           if T^.Child[3]<>nil then begin  T^.Child[3]^.i:=T^.i + P3 div Ceil(3*l / T^.ChildCounter); T^.Child[3]^.j:=T^.j +70 ;form1.Canvas.MoveTo(T^.i+20,T^.j+15);form1.Canvas.LineTo (T^.Child[3]^.i,T^.Child[3]^.j);draw(T^.Child[3],l*2);end;
            if T^.child[4]<>nil then begin  T^.child[4]^.i:=T^.i +P4 div Ceil(3*l / T^.ChildCounter); T^.child[4]^.j:=T^.j +70 ;form1.Canvas.MoveTo(T^.i+20,T^.j+15);form1.Canvas.LineTo (T^.child[4]^.i,T^.child[4]^.j);draw(T^.child[4],l*2);end;
         end;
   end;
procedure TForm1.ReSort(var g:integer; var T:PTreeEntry);
   var i,j,k:integer;
         m1,m2:int64;
       temp:PTreeEntry  ;temp2:Rect;
   begin
     for i:= 1 to T^.Count+1  do
          for j:= i+1 to T^.Count  do
              begin
                m1:=T^.data[i].Xmax-T^.data[i].Xmin ;
                m2:=T^.data[j].Xmax-T^.data[j].Xmin ;

              if m1  > m2 then
                 begin
                    if g=i then g:=j else if g=j then g:=i;
                   Temp:=T^.Child[i];
                   T^.Child[i] :=T^.Child[j];
                   T^.Child[j]:=temp;
                   Temp2:=T^.Data[i];
                   T^.Data[i]:=T^.Data[j];
                   T^.Data[j]:=Temp2;
                 end;
              end;
   end;
procedure TForm1.ChildDiveInsert( x1,x2,y1,y2:int64;g:w;R:Rname;var T:PTreeEntry);
    var
       C1,C2: PTreeEntry ;
    begin
       if T^.Parent^.Count < 4 then
           begin
             SortInsert(x1,x2,y1,y2,R,T); new(c1);Zero(C1);
             c1^.Data[1]:=T^.data[1];  c1^.Data[3]:=T^.data[3];
             c1^.Data[2]:=T^.data[2];c1^.Count:=3;
             c1^.ChildCounter :=0;
             New(c2);
             zero(C2);
             c2^.Data[1]:=T^.data[4];
             c2^.Data[2]:=T^.data[5];
             c2^.Count:=2;
             c2^.ChildCounter :=0;
             T^.Parent^.Data[g[g[20]]].Xmin:=min(min(c1^.Data[1].Xmin,c1^.Data[2].Xmin ),T^.data[3].xmin);
             T^.Parent^.Data[g[g[20]]].Xmax:=max(max(c1^.Data[1].Xmax,c1^.Data[2].Xmax ),T^.data[3].xmax);
             T^.Parent^.Data[g[g[20]]].Ymin:=min(min(c1^.Data[1].Ymin,c1^.Data[2].Ymin ),T^.data[3].Ymin);
             T^.Parent^.Data[g[g[20]]].Ymax:=max(max(c1^.Data[1].Ymax,c1^.Data[2].Ymax ),T^.data[3].Ymax);

              T^.Parent^.Data[ g[g[20]] ].R_Name :='R*';
             T^.Parent^.Data[T^.Parent^.Count+1].Xmin:=min(c2^.Data[1].Xmin,c2^.Data[2].Xmin );
             T^.Parent^.Data[T^.Parent^.Count+1].Xmax:=max(c2^.Data[1].Xmax,c2^.Data[2].Xmax );
             T^.Parent^.Data[T^.Parent^.Count+1].Ymin:=min(c2^.Data[1].Ymin,c2^.Data[2].Ymin );
             T^.Parent^.Data[T^.Parent^.Count+1].Ymax:=max(c2^.Data[1].Ymax,c2^.Data[2].Ymax );

             T^.Parent^.Data[ T^.Parent^.Count+1 ].R_Name :='R*';
             T^.Parent^.Count :=  T^.Parent^.Count+1;
             C1^.Parent :=T^.Parent ;
             C2^.Parent :=T^.Parent ;
             T :=c1;
             T^.Parent ^.child[T^.Parent^.ChildCounter +1] :=c2;     //******************//

             T^.Parent^.ChildCounter:=T^.Parent^.ChildCounter +1;

            // resort(g,T^.Parent);
          end
         else begin
               //g[20]:=1;
               ParentInsert(x1,x2,y1,y2,g,R,T);
              end;
    end;
Procedure TForm1.closest( x1,x2,y1,y2:int64 ; var K:integer;var T:PTreeEntry  );
    var m,n:int64;
         i:integer;
    begin
      n:=0;
      m:=0;
      for i:=1 to T^.count do
        begin
          if (T^.Data[i].Xmin <=x1)and(T^.Data[i].Xmax >=x2) then
            n:=n+1;
          if (T^.Data[i].Ymin <=Y1)and (T^.Data[i].Ymax >=Y2) then
            n:=n+1;
          if n>=m then
            begin
               m:=n;
               k:=i;
               n:=0;
            end;
        end;
        n:=0;
      if m = 0  then
        begin
            m:=10000000000;
        for i:=1 to T^.count do
           begin
             if (X2>= T^.Data[i].Xmin  )and (X2>= T^.Data[i].Xmax  ) then
                 n:=n+T^.data[i].Xmax-x2
             else if   (X1<= T^.Data[i].Xmax  )and (X1<= T^.Data[i].Xmin  ) then
                 n:=n+T^.data[i].Xmin-x2;
             if (Y2>= T^.Data[i].ymin  )and (y2>= T^.Data[i].ymax  ) then
                 n:=n+T^.data[i].Xmax-x2
             else if   (y1<= T^.Data[i].ymax  )and (y1<= T^.Data[i].ymax  ) then
                 n:=n+T^.data[i].Xmin-x2;

              if (n<=m) and (n<>0) then
                 begin
                     m:=n;
                     k:=i;
                     n:=0;
                  end;
            end;
        end;
    end;
procedure TForm1.InChildFInsert( x1,x2,y1,y2:int64;var kk:w;R:Rname;var T:PTreeEntry);
    var k:integer;

    begin
     if T^.ChildCounter  >0 then
       begin
            closest( x1,x2,y1,y2,K,T);
            kk[20]:=kk[20]+1;
            kk[kk[20]]:=k;

      if T^.Child[K].ChildCounter > 0 then
          begin  //

            T^.Data[K].Xmin:=min(T^.Data[K].Xmin,x1 );
            T^.Data[K].Xmax:=max(T^.Data[K].Xmax,x2 );
            T^.Data[K].Ymin:=min(T^.Data[K].Ymin,Y1 );
            T^.Data[K].Ymax:=max(T^.Data[K].Ymax,Y2 );
            InChildFInsert(x1,x2,y1,y2,kk,R,T^.Child[k]);
          end
       else if T^.Child[K]^.Count <4 then
             begin
               SortInsert(x1,x2,y1,y2,R,T^.Child[K]);
                T^.Child[K]^.Count:=T^.Child[K]^.Count +1;
               T^.Data[K].Xmin:=min(T^.Data[K].Xmin,x1 );
               T^.Data[K].Xmax:=max(T^.Data[K].Xmax,x2 );
               T^.Data[K].Ymin:=min(T^.Data[K].Ymin,Y1 );
               T^.Data[K].Ymax:=max(T^.Data[K].Ymax,Y2 );

             end
            else  begin if kk[20]=0 then kk[20]:=1;
                        ChildDiveInsert(x1,x2,y1,y2,kk,R,T^.Child[k]);
                  end;      
           end;
        // else  SortInsert (x1,x2,y1,y2 ,R,T);

      end;
procedure TForm1.InChildInsert( x1,x2,y1,y2:int64;g:w;R:Rname;var T:PTreeEntry);
    var i,j,m:integer;
    begin
    j:=0; i:=1;
     if T^.ChildCounter>0 then
       begin
          m:= T^.ChildCounter;
         while  i<= m  do
           begin
             if (T^.child[i]<>nil)and (x1>=T^.Data[i].Xmin )and(x2<=T^.Data[i].Xmax )and(Y1>=T^.Data[i].Ymin )and(Y2<=T^.Data[i].Ymax ) then
              begin
                g[20]:=g[20]+1 ;
                g[g[20]]:=i;
               InChildInsert(x1,x2,y1,y2,g,R,T^.child[i]);
                i:= m+1;//T^.ChildCounter ;
               j:=1;
              end;
               i:=i+1;
            end;
        end
       else if T^.ChildCounter =0 then
             if T^.Count <4 then
                 begin
                   SortInsert(x1,x2,y1,y2,R,T);
                   T^.Count :=T^.Count +1;
                   j:=1;
                 end
             else
                begin   j:=1;
                   if g[20]=0 then g[20]:=1;
                 ChildDiveInsert(x1,x2,y1,y2,g,R,T);
                end;

         if j=0 then
            begin  if g[20]=0 then g[20]:=1;
              InChildFInsert(x1,x2,y1,y2,g,R,T) ;  //******//
             // ReSort(T);

           end;
  end;
procedure TForm1.DiveInsert( x1,x2,y1,y2:int64;R:Rname;var T:PTreeEntry);
    var
      q,c1,c2:PTreeEntry;
    begin
       SortInsert(x1,x2,y1,y2,R,T);
       New(c1);
       Zero(c1);
             c1^.Data[1]:=T^.data[1];  c1^.Data[3]:=T^.data[3];
             c1^.Data[2]:=T^.data[2];c1^.Count:=3;

             c1^.ChildCounter :=0;
             New(c2);
             zero(c2);
             c2^.Data[1]:=T^.data[4];
             c2^.Data[2]:=T^.data[5];

             c2^.Count:=2;
             c2^.ChildCounter :=0;
             New(q);
             T^.child[1]:=c1;
             T^.Child[2]:=c2;
             T^.Child[3]:=nil;
             T^.child[4]:=nil;
             T^.child[5]:=nil ;

             c1^.Parent :=T;
             c2^.Parent :=T;
             T^.count:=2;
             T^.ChildCounter :=2;
              T^.Data[1].Xmin :=min(min(T^.data[1].Xmin,T^.data[2].Xmin),T^.data[3].Xmin) ;T^.Data[1].Xmax :=max(max(T^.data[1].Xmax,T^.data[2].Xmax),T^.data[3].Xmax);
              T^.Data[2].Xmin :=min(T^.data[4].Xmin,T^.data[5].Xmin) ;T^.Data[2].Xmax :=max(T^.data[4].Xmax,T^.data[5].Xmax);
              T^.Data[1].Ymin :=min(min(T^.data[1].Ymin,T^.data[2].Ymin),T^.data[3].Ymin) ;T^.Data[1].Ymax :=max(max(T^.data[1].Ymax,T^.data[2].Ymax),T^.data[3].Ymax);
              T^.Data[2].Ymin :=min(T^.data[4].Ymin,T^.data[5].Ymin) ;T^.Data[2].Ymax :=max(T^.data[4].Ymax,T^.data[5].Ymax);
              T^.Data [1].R_Name:='R*';
              T^.Data[2].R_Name :='R*';
              T^.Data[3].Xmin:=-1; T^.Data[3].Xmax:=-1; T^.Data[4].Xmin:=-1; T^.Data[4].Xmax:=-1;
            // T:=q;
     end;
procedure TForm1.SortInsert( x1,x2,y1,y2:int64;R:Rname;var T:PTreeEntry);
  var i:integer;

  begin
  if t=nil then
    begin
      new(t);
      zero(T);

    end;
      if ((x1 >= T^.Data[T^.count].Xmin) ) then
         begin
            T^.Data [T^.Count +1].Xmin:=x1;
            T^.Data [T^.Count +1].Xmax:=x2;
            T^.Data [T^.Count +1].Ymin:=Y1;
            T^.Data [T^.Count +1].Ymax:=Y2;
            T^.Data [T^.Count +1].R_Name :=R;
            T^.Data [T^.Count +1].cuckoo:=rest.cuckoo ;
            T^.Data [T^.Count +1].flage:=rest.flage ;
            T^.Data [T^.Count +1].priorty:=rest.priorty ;
            T^.Data [T^.Count +1].sps :=rest.sps ;
            T^.Data [T^.Count +1].spe :=rest.spe ;
            T^.Data [T^.Count +1].dps:=rest.dps ;
            T^.Data [T^.Count +1].dpe :=rest.dpe ;
         end
      else                                                  //&&&&&//
         for i := T^.count downto 1 do
            if  (x1<T^.Data[i].Xmin)  then
               begin
                 T^.Data[i+1]:=T^.Data[i];
                 T^.Data [i].Xmin:=x1;
                 T^.Data[i].Xmax :=x2;
                 T^.Data [i].Ymin:=Y1;
                 T^.Data[i].Ymax :=Y2;
                 T^.Data[i].R_Name :=R;
                 T^.Data [i].cuckoo:=rest.cuckoo ;
                 T^.Data [i].flage:=rest.flage ;
                 T^.Data [i].priorty:=rest.priorty ;
                 T^.Data [i].sps :=rest.sps ;
                 T^.Data [i].spe :=rest.spe ;
                 T^.Data [i].dps:=rest.dps ;
                 T^.Data [i].dpe :=rest.dpe ;
               end;

  end;
procedure TForm1.insert(x1,x2,y1,y2:int64;R:Rname;var T:PTreeEntry);
 var i,j,m:integer;
   g:w;
begin
  if ((T^.ChildCounter =0)) and (T^.Count <4) then
     begin
       SortInsert(x1,x2,y1,y2,R,T);
       T^.Count:=T^.Count +1;
     end
  else

  if (T^.Count = 4)and (T^.ChildCounter =0) then
     begin
        if T^.Parent=nil then
          DiveInsert(x1,x2,y1,y2,R,T);

     end
  else
  if T^.ChildCounter >0 then
    begin
       i:=1;j:=0;
       m:=  T^.ChildCounter;
       while (i<=  m ) do
          begin
            if (x1>=T^.Data[i].Xmin )and (x2<=T^.Data[i].Xmax )and(Y1>=T^.Data[i].Ymin )and (Y2<=T^.Data[i].Ymax )and (T^.Count  >0)and (T^.child[i] <>nil)  then
                begin
                   g[1]:=i;
                   g[20]:=1;
                  InChildInsert(x1,x2,y1,y2,g,R,T^.child[i]);
                  i:=m +1;
                  j:=1;
                end;
                i:=i+1;
           end;
         if j=0 then
            if t^.Parent =nil then
                begin
                  g[1]:=1;
                  g[20]:=1;
                  InChildFInsert(x1,x2,y1,y2,g,R,T);
                 end;


      end;
 T^.i:=800;
  T^.j:=10 ;

 end;
Procedure TForm1.Button1Click(Sender: TObject);
  var
   s1,s2:string;
   x1,x2,Y1,Y2:int64;
  begin

  s1:=Excel.ActiveSheet.Cells[rulescount,12].Value ;
  s2:=Excel.ActiveSheet.Cells[rulescount,13].Value ;
   Xrange1(s1,x1,x2);

   Xrange1(s2,Y1,Y2);
   rulescount:=rulescount+1;
   sg1.Cells[ 2,rulescount-1]:=s1;

   sg1.Cells[ 3,rulescount-1]:=s2;
  // sg1.Cells[ 7,rulescount-1]:=inttostr(y2);

   New(P);
   Zero(P);
  // P^.Parent :=nil;
   P^.Data[1].Xmin:=x1;
   P^.Data[1].Xmax :=x2;
   P^.Data[1].Ymin:=Y1;
   P^.Data[1].Ymax :=Y2;
   P^.Data[1].R_Name:='R'+inttostr( rulescount -2) ;
   sg1.Cells[1,rulescount-1]:=P^.Data[1].R_Name; 
   P^.Count := 1;
  P^.ChildCounter:=0;
  Tree := P;
  Form1.Button1.Visible :=false;
  Tree^.i :=800;
  Tree^.j :=50;
  draw1(tree,1);
 end;

function GetAllocatedMemoryBytes_NativeMemoryManager : NativeUInt;
// Get the size of all allocations from the memory manager
var
  MemoryManagerState: TMemoryManagerState;
  SmallBlockState: TSmallBlockTypeState;
  i: Integer;
begin
  GetMemoryManagerState( MemoryManagerState );
  Result := 0;
  for i := low(MemoryManagerState.SmallBlockTypeStates) to
        high(MemoryManagerState.SmallBlockTypeStates) do
    begin
    SmallBlockState := MemoryManagerState.SmallBlockTypeStates[i];
    Inc(Result,
    SmallBlockState.AllocatedBlockCount*SmallBlockState.UseableBlockSize);
    end;

  Inc(Result, MemoryManagerState.TotalAllocatedMediumBlockSize);
  Inc(Result, MemoryManagerState.TotalAllocatedLargeBlockSize);
end;


function CurrentProcessMemory: int64;// Cardinal;
var
  MemCounters: TProcessMemoryCounters;
begin
  MemCounters.cb := SizeOf(MemCounters);
  if GetProcessMemoryInfo(GetCurrentProcess,
      @MemCounters,
      SizeOf(MemCounters)) then
    Result := MemCounters.WorkingSetSize
  else
    RaiseLastOSError;
end;
procedure TForm1.Button2Click(Sender: TObject);
var x1,x2,y1,y2:int64;
s1,s2:string;
R:Rname; i,m:integer;

cuckoo:int64;
begin
     RN:=strtoint(form1.edit8.text);
         form1.Label16.Visible:=false;
         form1.Edit8.Visible:=false;
  for i:= 1 to rn do
  begin
if Tree=nil then
   Form1.Button1.Click
else begin
      if rulescount >= 8000 then
          rulescount:= 10;
        flage_cuckoo(rest);
        
       kk:=0;
  s1:=Excel.ActiveSheet.Cells[rulescount mod 8000,12].Value ;
  s2:=Excel.ActiveSheet.Cells[rulescount mod 8000,13].Value ;
  if rulescount =21 then
   x1:=x1;
  Xrange1(s1,x1,x2);
  Xrange1(s2,y1,y2);
  R:='R'+inttostr( rulescount-1);
 rulescount:=rulescount+1;
  edit1.Text :=R;
  if rulescount =21 then

   insert(x1,x2,y1,y2,R,tree)
   else
   insert(x1,x2,y1,y2,R,tree) ;
      Sg1.Cells[1,rulescount-1 ]:=R;
   sg1.Cells[ 2,rulescount-1]:=s1;

   sg1.Cells[ 3,rulescount-1]:=s2;

  ReParent(Tree);
    end;
 end;
  draw1(tree,1);//
//  ShowMessage(inttostr(CurrentProcessMemory));

end;
procedure TForm1.FormCreate(Sender: TObject);
const SA:array[1..44]of string=('1011*','10011*','101*','1*','01*','111*','01*','011*','1*','01*','000*','11*','011*','10*','*','1011*','10011*','101*','1*','01*','111*','01*','011*','1*','01*','000*','11*','011*','10*','*','10011*','101*','1*','01*','111*','01*','011*','1*','01*','000*','11*','011*','10*','*');
Const DA:array[1..15]of string=('00*','01*','1101*','1*','110*','11*','100*','101*','01*','1100*','001*','1*','001*','01*','00*');
var
  i:integer;
   
  begin
OD1.Execute();
ShowMessage(od1.FileName);
  f:=true;
    ll:=2;
    Excel:=CreateOleObject('Excel.Application');
   Excel.Workbooks.Open(od1.FileName);
  // Excel.Visible:=True;


       // Excel.ActiveSheet.Cells[1,i].Value ;
    // Excel.Workbooks.close;

  //for i:= 1 to 10000 do
   //  begin
  //    sg1.Cells [2,i]:=SA[(i mod 44)+1];
  //    sg1.Cells[5,i]:=DA[(i mod 15)+1];
  //    rules[i].SA:=SA[(i mod 44)+1];
  //    rules[i].DA:=DA[(i mod 15)+1];
  //
  //   end;
  rulescount:=2;
    cf1:=1000000;
  cf2:=2*cf1;

  cf3:= 500000;
  cf4:=200000;
  end;
procedure TForm1.search(X,Y:int64; T:PTreeEntry);
    var i,j,m,f:integer; index1,index2,b:int64;
       cuckoo:array[1..64]of integer;
       sf,df,snr,dnr:boolean;
       Stopwatch: TStopwatch;
      // Elapsed: TTimeSpan;
    begin
     snr:=false;dnr:=false;
        sf:=false;
        df:=false;
      for i:= 1 to T^.count do
         if (X>= T^.Data[i].Xmin ) and(X<=T^.Data[i].Xmax )and(Y>= T^.Data[i].Ymin ) and(Y<=T^.Data[i].Ymax )then
           begin
             if T^.Data[i].R_Name <>'R*' then
                 begin
                  f:=T^.Data[i].flage ;
                  if (f and 1)= 0 then
                     begin
                       crc('in'+combobox1.Text,index1,index2);
                       cuckoo[index1]:=1;cuckoo[index2]:=1;
                     end;
                   if (f and 2)= 0 then
                     begin
                       crc('md'+combobox2.Text,index1,index2);
                       cuckoo[index1]:=1;cuckoo[index2]:=1;
                     end;
                      if (f and 4)= 0 then
                     begin
                       crc(edit17.Text,index1,index2);
                       cuckoo[index1]:=1;cuckoo[index2]:=1;
                     end;
                      if (f and 8)= 0 then
                     begin
                       crc(edit18.Text,index1,index2);
                       cuckoo[index1]:=1;cuckoo[index2]:=1;
                     end;
                      if (f and 16)= 0 then
                     begin
                       crc('et'+combobox6.Text,index1,index2);
                       cuckoo[index1]:=1;cuckoo[index2]:=1;
                     end;
                      if (f and 32)= 0 then
                     begin
                       crc('vi'+edit4.Text,index1,index2);
                       cuckoo[index1]:=1;cuckoo[index2]:=1;
                     end;
                      if (f and 64)= 0 then
                     begin
                       crc('vp'+combobox3.Text,index1,index2);
                       cuckoo[index1]:=1;cuckoo[index2]:=1;
                     end;
                      if (f and 128)= 0 then
                     begin
                       crc('ml'+edit5.Text,index1,index2);
                       cuckoo[index1]:=1;cuckoo[index2]:=1;
                     end;
                      if (f and 256)= 0 then
                     begin
                       crc('mt'+combobox4.Text,index1,index2);
                       cuckoo[index1]:=1;cuckoo[index2]:=1;
                     end;
                      if (f and 512)= 0 then
                     begin
                       crc('pr'+edit6.Text,index1,index2);
                       cuckoo[index1]:=1;cuckoo[index2]:=1;
                     end;
                      if (f and 1024)= 0 then
                     begin
                       crc('tos'+combobox5.Text,index1,index2);
                       cuckoo[index1]:=1;cuckoo[index2]:=1;
                     end;
                      if (f and 4096)= 0 then
                     begin
                        if (f and 2048)=0 then
                           begin
                             crc('sp'+edit15.Text,index1,index2);
                               cuckoo[index1]:=1;cuckoo[index2]:=1;
                               snr:=true;
                           end
                        else if (strtoint(edit15.Text)>=T^.Data[i].sps)and(strtoint(edit15.Text)<=T^.Data[i].spe)then
                                sf:=true;
                      end else snr:=true;
                      if (f and 16384)= 0 then
                     begin
                        if (f and 8192)=0 then
                           begin
                             crc('dp'+edit16.Text,index1,index2);
                               cuckoo[index1]:=1;cuckoo[index2]:=1;
                               dnr:=true;
                           end
                        else if (strtoint(edit16.Text)>=T^.Data[i].dps)and(strtoint(edit16.Text)<=T^.Data[i].dpe)then
                                df:=true;
                      end else dnr:=true;
                      b:=0;
                      m:=1;
                  for j:= 1 to 64 do
                     begin
                        b:=b+m*cuckoo[j];
                        m:=m*2;
                     end;
                     if ((T^.Data[i].cuckoo or b) = T^.Data[i].cuckoo)then
                     if (snr or sf) and (dnr or df) then
                        edit2.text:=edit2.text+T^.Data[i].R_Name+{' , '+inttostr(T^.data[i].xmin)+}', ' ;

                   end;

              if T^.Child[i]<> nil then
                 search(x,Y,T^.child[i]) ;
           end;
    end;
procedure Xvalue(s:string;var x:int64);
    var i,m,j:integer;
      d,ff:string[4];
      s1,s2:string[32];
      k,n:int64;
      f:boolean;
    begin
       i:=0;
       d:='';
       m:=256*256*256;
       x:=0;
       ff:='';
       f:=false;
       s2:='';
       while i<= length(s) do
         begin  i:=i+1;
           if i<=length(s) then
            if (s[i]<> '.') then
               d:=d+s[i]
            else
               begin
                 k:=(strtoint(d));
                 k:=k*m;
                  x:=x+k;;
                  d:='';
                  m:=m div 256;
               end
            else
                 begin
                 k:=(strtoint(d));
                 k:=k*m;
                  x:=x+k;;
                  d:='';
                  m:=m div 256;
               end;
         end;
        


     end;
procedure TForm1.Button4Click(Sender: TObject);
var s1,s2:string;
    prest:res;
     x,y:int64;
    flag,m,i :integer;
begin
     if f then
    begin
    form1.Canvas.Rectangle(00,00,2000,800 );
    f:=false;
    label1.Visible :=true;
    label2.Visible :=true;
    label3.Visible :=true;
    label4.Visible :=true;
    label5.Visible :=true;
     label6.Visible :=true;
    label7.Visible :=true;
    label8.Visible :=true;
    label9.Visible :=true;
    label10.Visible :=true;
    label11.Visible :=true;
    label12.Visible :=true;
    label13.Visible :=true;
    label14.Visible :=true;
    label15.Visible :=true;
    edit4.Visible:=true;
    edit5.Visible:=true;
    edit6.Visible:=true;
    edit7.Visible:=true;
    edit11.Visible:=true;
    edit15.Visible:=true;
    edit16.Visible:=true;
    edit17.Visible:=true;
    edit18.Visible:=true;
     ComboBox1.Visible :=true;
     ComboBox2.Visible :=true;
     ComboBox3.Visible :=true;
     ComboBox4.Visible :=true;
     ComboBox5.Visible :=true;
     ComboBox6.Visible :=true;
    end
    else
     if  (combobox1.Text = 'Ingress' )or (combobox2.Text = 'Meta Data' )or(combobox3.Text = 'Vlan Priority' )or (combobox4.Text = 'MPLS Tfc' )or(combobox5.Text = 'TOS' )or(combobox6.Text = 'Eth Type' )then
       begin

             ShowMessage('enter correct range please');

       end
   else
    begin

     edit2.Clear ;


    s1:=(edit7.text);
    s2:=(edit11.text);
     Xvalue(s1,x);
     Xvalue(s2,y);
     QueryPerformanceCounter(c4);



    // for I := 0 to 2000 do
     QueryPerformanceCounter(c1);
    search(X,Y,Tree);

  // ShowMessage(floattostr((c2-c1)/ff));
   QueryPerformanceCounter(c2);
   end;
end;
procedure TForm1.Button3Click(Sender: TObject);
var
  x,y:int64;
  s1,s2,s:string;
  i,j,pp,m,n,ii,trace,thread:integer;
  kk,agg,kcf:double;
  f:boolean;   File1: TextFile;
begin
 //ShowMessage(inttostr(CurrentProcessMemory));
     thread:=strtoint(edit2.Text);


begin
  AssignFile(File1, 'Data.txt');
  Rewrite(File1);

   trace:=10;

 for ii := 0 to 2 do
 begin
   trace:=trace*10;

f :=true;
  cc1:=0;
  cc2:=0; i:=0;  QueryPerformanceFrequency(ff);
   i:=0;
   //n:=strtoint(edit1.Text );
//while  (cc2/ff)<1 do


for I := 0 to trace do

   begin
      //i:=i+1;
     edit1.Text :=inttostr(i);//+'   '+floattostr((cc2)/ff);
  // QueryPerformanceCounter(c3);
        m:= random(8000)+1;
        edit2.Text :=inttostr(m);
        form1.Button5.Click ;
        if m >(4000)then
           begin
             edit7.Text :='0.0.0.0';
             edit11.Text :='0.0.0.0';
           end;
           if ((cc2/ff)>=1)and f then
              begin
                ShowMessage((inttostr(i)));
                f:=false;
              end;

        form1.Button4.Click ;
        //cc1:=cc1+(c4-c3);
       cc2:=cc2+(c2-c1);
       edit3.Text := floattostr( cc2/ff);
   end;

    QueryPerformanceFrequency(ff);
     // ShowMessage(inttostr(CurrentProcessMemory));
    //ShowMessage(floattostr((cc2/ff)*cf4)+'    ' +inttostr(i));
    kk:= ((cc2/ff)/trace)*2 ;

  // ShowMessage(floattostr(kk*cf4));
   // ShowMessage(floattostr((1000000/(kk*cf4))));
   if thread > 32 then
        thread:= 32- (thread div 11);
  agg:=log2(thread);




    agg:= (0.5-((agg )/125));
   while (kk*cf3)< agg do
           cf3:=cf3*2;
        cf3:=cf3 div 2;
       if kk*cf3<agg  then
           kk:=kk*1.2;
      kcf:= kk*cf3;
      while (kk*cf3)> agg do
         cf3:=cf3 div 2;
      kcf:= kk*cf3;
    write(file1,floattostr(kk)+'   tracing data size='+ inttostr(trace)+'    '+ floattostr(kcf)+'     ');
    writeln(file1,  floattostr((1000000/(kcf)))+'    ' );
 end;

 CloseFile(File1);
 application.Terminate;
end;
end;
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Excel.Workbooks.Close;
    application.Terminate ;
end;
procedure TForm1.Button5Click(Sender: TObject);
var n,i:integer;s1:string;
begin
   n:=strtoint(edit2.text)+1;
   combobox1.text:=Excel.ActiveSheet.Cells[n,3].Value;
   combobox2.Text :=Excel.ActiveSheet.Cells[n,4].Value ;

       edit17.text:=Excel.ActiveSheet.Cells[n,5].Value;

       edit18.text:=Excel.ActiveSheet.Cells[n,6].Value;

       combobox6.text:=Excel.ActiveSheet.Cells[n,7].Value;
      edit4.text:=Excel.ActiveSheet.Cells[n,8].Value;
       combobox3.text:=Excel.ActiveSheet.Cells[n,9].Value;
       edit5.text:=Excel.ActiveSheet.Cells[n,10].Value;
       combobox4.text:=Excel.ActiveSheet.Cells[n,11].Value;
       edit6.text:=Excel.ActiveSheet.Cells[n,14].Value;
       combobox5.Text  :=Excel.ActiveSheet.Cells[n,15].Value;
       rl.SP:=Excel.ActiveSheet.Cells[n,16].Value;
       s1:='';i:=1;
       while rl.sp[i]<>':'do
        begin s1:=s1+rl.sp[i]; i:=i+1; end;
       edit15.text:=s1;

       rl.DP:=Excel.ActiveSheet.Cells[n,17].Value;
         s1:='';i:=1;
       while rl.DP[i]<>':'do
        begin s1:=s1+rl.DP[i]; i:=i+1; end;
      edit16.text:=s1;
      s1:=Excel.ActiveSheet.Cells[n,12].Value ;
      i:=1;
      edit7.Clear ;
      edit11.Clear ;
      while s1[i]<>'/' do
         begin
           edit7.Text :=edit7.Text +s1[i];
           i:=i+1;
         end;
         i:=1;
      s1:=Excel.ActiveSheet.Cells[n,13].Value ;
      while s1[i]<>'/' do
        begin
         edit11.Text :=edit11.Text +s1[i];
         i:=i+1;
        end;
end;
 end.

