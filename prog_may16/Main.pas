unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TMainForm = class(TForm)
    OpenPort: TButton;
    ClosePort: TButton;
    SendData: TButton;
    Edit1: TEdit;
    PortStateLabel: TLabel;
    btnUp: TButton;
    btnDown: TButton;
    btnLeft: TButton;
    btnRight: TButton;
    procedure OpenPortClick(Sender: TObject);
    procedure ClosePortClick(Sender: TObject);
    procedure SendDataClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure btnUpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnUpMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnDownMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnDownMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnLeftMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnLeftMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnRightMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnRightMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation
Var
Port:THandle;

{$R *.dfm}

procedure TMainForm.OpenPortClick(Sender: TObject);
Var
 DCB:TDCB;    //���������, ���������� ��������� �����
 CommTimeouts:TCommTimeouts;
begin
  Port:=CreateFile(
    '\\.\COM11',                   //��������� ������� ����
    GENERIC_READ or GENERIC_WRITE,//��������� ���� ��� ������ � ������
    0,                            //����� ������ � ������� ��������, ��� ������ ������ ���
    nil,                          //�������� ������, �� ������������ � ������ nil
    OPEN_EXISTING,                //�������� ��������, ��� ������ OPEN_EXISTING
    FILE_ATTRIBUTE_NORMAL,         //��� ���������� ������ ���
    0
  );
 if (port=INVALID_HANDLE_VALUE)  //���� ���� �� �������
  then showmessage('���� �� ��������! ���������, �� ���������� �� ���� ������ ���������� � ��������� ����������� ����������.') //�� ������� ��������� �� ������
  else POrtStateLabel.Caption:='���� ������';       //���� ���� ��������, �� ����� ��� ��������

  GetCommState(port, DCB);        //��� �� �� ��������� ��� ��������� �����, ������ ��������� ��, ����� �������� ������ ����
  DCB.BaudRate:=9600;             // �������� ������
  DCB.Parity:=NoParity;           // ��� �������� ��������
  DCB.ByteSize:=8;                //������ ��������
  DCB.StopBits:=ONESTOPBIT;       //���� �������� ���
  SetCommState(port, DCB);        //���������� ���������� ���������, ��� ��������� �����

  GetCommTimeouts(Port, CommTimeouts); //�������� ��������� CommTimeouts ��� �� �� ��������� ��� �������
  CommTimeouts.ReadIntervalTimeout :=MAXDWORD;  //������� ReadFile ����������
  CommTimeouts.ReadTotalTimeoutMultiplier := 0; //���������� ��� ���������
  CommTimeouts.ReadTotalTimeoutConstant := 0;   //����� � �������� ������
  CommTimeouts.WriteTotalTimeoutMultiplier := 0;//����� ����-��� ���
  CommTimeouts.WriteTotalTimeoutConstant := 0;  //�������� ������ �� ������������.
  SetCommTimeouts(Port, CommTimeouts); //���������� ���������� ���������

end;


procedure TMainForm.ClosePortClick(Sender: TObject);
begin
 if not CloseHandle(Port)                 //���� ����  �� ��������
  then showmessage('�� ���������')        //�� ����� ��� �� �� ��������
  else PortStateLabel.Caption:='���� �� ������'   //���� ������� �������� , �� �����, ��� �������� :)
end;

procedure TMainForm.SendDataClick(Sender: TObject);
var
  TRBuf:PChar;    //����� ������ ��� ��������
  nToWrite:DWord; //����� ���� ��� ������
  nWrite:DWord;   //����� ���������� ����
begin
  TRBuf:=PChar(Edit1.Text);         //��������� ����� �������
  nToWrite:=length(TRBuf)+1;        //����� ������������ ����
  WriteFile(port,TRBuf^,nToWrite,nWrite,nil); //���������� ��������� ������
//  WriteFile(port,Edit1.Text[1],nToWrite,nWrite,nil); //���������� ��������� ������
//  WriteFile(port,TRBuf[0],nToWrite,nWrite,nil); //���������� ��������� ������
end;


procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//CloseHandle(Port)                 //��������� ����
end;




procedure TMainForm.btnUpMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  TRBuf:PChar;    //����� ������ ��� ��������
  nToWrite:DWord; //����� ���� ��� ������
  nWrite:DWord;
begin
  TRBuf:=PChar('005200');         //��������� ����� �������
  nToWrite:=6+1;        //����� ������������ ����
  WriteFile(port,TRBuf^,nToWrite,nWrite,nil); //���������� ��������� ������
end;



procedure TMainForm.btnUpMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  TRBuf:PChar;    //����� ������ ��� ��������
  nToWrite:DWord; //����� ���� ��� ������
  nWrite:DWord;
begin
  TRBuf:=PChar('000000');         //��������� ����� �������
  nToWrite:=6+1;        //����� ������������ ����
  WriteFile(port,TRBuf^,nToWrite,nWrite,nil); //���������� ��������� ������
end;



procedure TMainForm.btnDownMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  TRBuf:PChar;    //����� ������ ��� ��������
  nToWrite:DWord; //����� ���� ��� ������
  nWrite:DWord;
begin
  TRBuf:=PChar('006200');         //��������� ����� �������
  nToWrite:=6+1;        //����� ������������ ����
  WriteFile(port,TRBuf^,nToWrite,nWrite,nil); //���������� ��������� ������
end;


procedure TMainForm.btnDownMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  TRBuf:PChar;    //����� ������ ��� ��������
  nToWrite:DWord; //����� ���� ��� ������
  nWrite:DWord;
begin
  TRBuf:=PChar('000000');         //��������� ����� �������
  nToWrite:=6+1;        //����� ������������ ����
  WriteFile(port,TRBuf^,nToWrite,nWrite,nil); //���������� ��������� ������
end;


procedure TMainForm.btnLeftMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  TRBuf:PChar;    //����� ������ ��� ��������
  nToWrite:DWord; //����� ���� ��� ������
  nWrite:DWord;
begin
  TRBuf:=PChar('002200003200');         //��������� ����� �������
  nToWrite:=13;        //����� ������������ ����
  WriteFile(port,TRBuf^,nToWrite,nWrite,nil); //���������� ��������� ������
end;

procedure TMainForm.btnLeftMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  TRBuf:PChar;    //����� ������ ��� ��������
  nToWrite:DWord; //����� ���� ��� ������
  nWrite:DWord;
begin
  TRBuf:=PChar('000000');         //��������� ����� �������
  nToWrite:=6+1;        //����� ������������ ����
  WriteFile(port,TRBuf^,nToWrite,nWrite,nil); //���������� ��������� ������
end;

procedure TMainForm.btnRightMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  TRBuf:PChar;    //����� ������ ��� ��������
  nToWrite:DWord; //����� ���� ��� ������
  nWrite:DWord;
begin
  TRBuf:=PChar('001200004200');         //��������� ����� �������
  nToWrite:=13;        //����� ������������ ����
  WriteFile(port,TRBuf^,nToWrite,nWrite,nil); //���������� ��������� ������
end;

procedure TMainForm.btnRightMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  TRBuf:PChar;    //����� ������ ��� ��������
  nToWrite:DWord; //����� ���� ��� ������
  nWrite:DWord;
begin
  TRBuf:=PChar('000000');         //��������� ����� �������
  nToWrite:=7;        //����� ������������ ����
  WriteFile(port,TRBuf^,nToWrite,nWrite,nil); //���������� ��������� ������
end;



end.
