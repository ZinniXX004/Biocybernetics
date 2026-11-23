object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 
    'Jeremia Christ Immanuel Manalu - 5023231017 - MPC Experimental S' +
    'teps (bilinear discretisation, Ho-Kalman SVD, observer)'
  ClientHeight = 880
  ClientWidth = 1400
  Color = 16117996
  Constraints.MinHeight = 760
  Constraints.MinWidth = 1200
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 15
  object pnlHeader: TPanel
    Tag = 11
    Left = 0
    Top = 0
    Width = 1400
    Height = 64
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Header'
    Color = 10569485
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 1398
    DesignSize = (
      1400
      64)
    object lblTitle: TLabel
      Left = 18
      Top = 6
      Width = 650
      Height = 30
      Caption = 'MPC Experimental Steps: Discretisation, Ho-Kalman and Observer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -22
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object lblSubtitle: TLabel
      Left = 18
      Top = 40
      Width = 448
      Height = 15
      Caption = 
        'Jeremia Christ Immanuel Manalu (5023231017), Biocybernetics Clas' +
        's Q, Assignment 4'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Transparent = True
      OnClick = lblSubtitleClick
    end
    object btnEquations: TPanel
      Tag = 5
      Left = 822
      Top = 14
      Width = 120
      Height = 36
      Cursor = crHandPoint
      Hint = 'Show the equations used by the program'
      Anchors = [akTop, akRight]
      BevelOuter = bvNone
      Caption = 'Equations (F1)'
      Color = 12608789
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnEquationsClick
      ExplicitLeft = 820
    end
    object btnExportCSV: TPanel
      Tag = 2
      Left = 950
      Top = 14
      Width = 110
      Height = 36
      Cursor = crHandPoint
      Hint = 'Save the data of the charts on the active tab'
      Anchors = [akTop, akRight]
      BevelOuter = bvNone
      Caption = 'Export CSV'
      Color = 12608789
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnExportCSVClick
      ExplicitLeft = 948
    end
    object btnExportPNG: TPanel
      Tag = 2
      Left = 1068
      Top = 14
      Width = 110
      Height = 36
      Cursor = crHandPoint
      Hint = 'Save the charts of the active tab as an image'
      Anchors = [akTop, akRight]
      BevelOuter = bvNone
      Caption = 'Export PNG'
      Color = 12608789
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnExportPNGClick
      ExplicitLeft = 1066
    end
    object btnClear: TPanel
      Tag = 7
      Left = 1186
      Top = 14
      Width = 100
      Height = 36
      Cursor = crHandPoint
      Hint = 'Clear every chart, result and message (asks first)'
      Anchors = [akTop, akRight]
      BevelOuter = bvNone
      Caption = 'CLEAR'
      Color = 12608789
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btnClearClick
      ExplicitLeft = 1184
    end
    object btnExit: TPanel
      Tag = 3
      Left = 1294
      Top = 14
      Width = 90
      Height = 36
      Cursor = crHandPoint
      Hint = 'Close the program'
      Anchors = [akTop, akRight]
      BevelOuter = bvNone
      Caption = 'EXIT'
      Color = 12608789
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = btnExitClick
      ExplicitLeft = 1292
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 760
    Width = 1400
    Height = 100
    Align = alBottom
    BevelOuter = bvNone
    Color = 16117996
    ParentBackground = False
    TabOrder = 1
    ExplicitTop = 752
    ExplicitWidth = 1398
    object cardLog: TPanel
      Tag = 13
      AlignWithMargins = True
      Left = 6
      Top = 0
      Width = 1388
      Height = 94
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Messages and warnings'
      Color = 15924223
      Padding.Left = 8
      Padding.Top = 30
      Padding.Right = 8
      Padding.Bottom = 4
      ParentBackground = False
      ShowCaption = False
      TabOrder = 0
      ExplicitWidth = 1386
      object redLog: TRichEdit
        Left = 8
        Top = 30
        Width = 1372
        Height = 60
        Align = alClient
        BorderStyle = bsNone
        Color = 15924223
        Font.Charset = ANSI_CHARSET
        Font.Color = 3682854
        Font.Height = -11
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        ExplicitWidth = 1370
      end
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 64
    Width = 1400
    Height = 696
    ActivePage = tsP1
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    ExplicitWidth = 1398
    ExplicitHeight = 688
    object tsP1: TTabSheet
      Caption = 'Problem 1: Bilinear Discretisation'
      object pnlP1Bg: TPanel
        Left = 0
        Top = 0
        Width = 1392
        Height = 666
        Align = alClient
        BevelOuter = bvNone
        Color = 16117996
        ParentBackground = False
        TabOrder = 0
        ExplicitWidth = 1390
        ExplicitHeight = 658
        object pnlP1Side: TPanel
          Left = 0
          Top = 0
          Width = 320
          Height = 666
          Align = alLeft
          BevelOuter = bvNone
          Color = 16117996
          Padding.Left = 6
          Padding.Top = 6
          Padding.Right = 6
          Padding.Bottom = 6
          ParentBackground = False
          TabOrder = 0
          ExplicitHeight = 658
          object cardP1System: TPanel
            Tag = 10
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 308
            Height = 162
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'System and discretisation method'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            object rgP1System: TRadioGroup
              Left = 8
              Top = 30
              Width = 292
              Height = 54
              Color = 16578805
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ItemIndex = 0
              Items.Strings = (
                'System 1 (third order, reference of the sheet)'
                'System 2 (s = +/-2j, undamped oscillation)')
              ParentBackground = False
              ParentColor = False
              ParentFont = False
              TabOrder = 0
              OnClick = rgP1SystemClick
            end
            object rgP1Method: TRadioGroup
              Left = 8
              Top = 88
              Width = 292
              Height = 70
              Color = 16578805
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ItemIndex = 0
              Items.Strings = (
                'Lecture bilinear: Bd with T / (1 - T/2)'
                'Standard bilinear: Bd with T'
                'Zero-order hold (exact samples)')
              ParentBackground = False
              ParentColor = False
              ParentFont = False
              TabOrder = 1
            end
          end
          object cardP1Model: TPanel
            Tag = 12
            AlignWithMargins = True
            Left = 6
            Top = 174
            Width = 308
            Height = 190
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Continuous model (editable)'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 1
            object vleP1Model: TValueListEditor
              Left = 8
              Top = 32
              Width = 292
              Height = 150
              Hint = 
                'One row of A per line, numbers separated by spaces. Reset loads ' +
                'the selected system.'
              ParentShowHint = False
              ShowHint = True
              Strings.Strings = (
                'A row 1=0 1 0'
                'A row 2=3 0 1'
                'A row 3=0 1 0'
                'B (column, top to bottom)=1 1 3'
                'C=0 1 0'
                'D=0')
              TabOrder = 0
              TitleCaptions.Strings = (
                'Parameter'
                'Value')
              ColWidths = (
                150
                136)
            end
          end
          object cardP1Sim: TPanel
            Tag = 12
            AlignWithMargins = True
            Left = 6
            Top = 370
            Width = 308
            Height = 164
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Sampling and simulation (editable)'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 2
            object vleP1Sim: TValueListEditor
              Left = 8
              Top = 32
              Width = 292
              Height = 90
              Hint = 
                'The sheet uses T = 0.001 s. System 1 grows, so 3 s are shown; sy' +
                'stem 2 uses 10 s.'
              ParentShowHint = False
              ShowHint = True
              Strings.Strings = (
                'Sampling time T (s)=0.001'
                'Simulation time (s)=3'
                'Step amplitude (-)=1')
              TabOrder = 0
              TitleCaptions.Strings = (
                'Parameter'
                'Value')
              ColWidths = (
                150
                115)
            end
            object chkP1PulseArea: TCheckBox
              Left = 10
              Top = 126
              Width = 290
              Height = 17
              Hint = 
                'Checked: u(0) = 1/T, comparable with the continuous impulse resp' +
                'onse. Unchecked: u(0) = 1, the response equals the Markov parame' +
                'ters.'
              Caption = 'Impulse as a pulse of area 1: u(0) = 1/T'
              Checked = True
              Color = 16578805
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 1
            end
            object chkP1Exact: TCheckBox
              Left = 10
              Top = 144
              Width = 290
              Height = 17
              Hint = 
                'Exact samples of the continuous model (zero-order hold for the s' +
                'tep, e^(AT) for the impulse)'
              Caption = 'Show the exact continuous response'
              Checked = True
              Color = 16578805
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 2
            end
          end
          object cardP1Run: TPanel
            Tag = 10
            AlignWithMargins = True
            Left = 6
            Top = 540
            Width = 308
            Height = 76
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Compute'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 3
            object btnP1Discretise: TPanel
              Tag = 1
              Left = 12
              Top = 34
              Width = 82
              Height = 32
              Cursor = crHandPoint
              Hint = 'Ad, Bd, Cd, Dd and the eigenvalues of Ad (Equations 1.4 to 1.8)'
              BevelOuter = bvNone
              Caption = 'Discretise'
              Color = 12608789
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = btnP1DiscretiseClick
            end
            object btnP1Simulate: TPanel
              Tag = 1
              Left = 97
              Top = 34
              Width = 118
              Height = 32
              Cursor = crHandPoint
              Hint = 'Discrete step and impulse response (Equation 1.9)'
              BevelOuter = bvNone
              Caption = 'Step and impulse'
              Color = 12608789
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnClick = btnP1SimulateClick
            end
            object btnP1Reset: TPanel
              Tag = 4
              Left = 218
              Top = 34
              Width = 82
              Height = 32
              Cursor = crHandPoint
              Hint = 'Load A, B, C, D and the simulation time of the selected system'
              BevelOuter = bvNone
              Caption = 'Reset model'
              Color = 12608789
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              OnClick = btnP1ResetClick
            end
          end
        end
        object gpP1: TGridPanel
          Left = 320
          Top = 0
          Width = 1072
          Height = 666
          Align = alClient
          BevelOuter = bvNone
          ColumnCollection = <
            item
              Value = 50.000000000000000000
            end
            item
              Value = 50.000000000000000000
            end>
          ControlCollection = <
            item
              Column = 0
              Control = cardP1Result
              Row = 0
            end
            item
              Column = 1
              Control = chtP1Poles
              Row = 0
            end
            item
              Column = 0
              Control = chtP1Step
              Row = 1
            end
            item
              Column = 1
              Control = chtP1Imp
              Row = 1
            end>
          ParentBackground = False
          RowCollection = <
            item
              Value = 50.000000000000000000
            end
            item
              Value = 50.000000000000000000
            end>
          TabOrder = 1
          ExplicitWidth = 1070
          ExplicitHeight = 658
          object cardP1Result: TPanel
            Tag = 14
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 530
            Height = 327
            Align = alClient
            BevelOuter = bvNone
            Caption = 'Discrete model (Ad, Bd, Cd, Dd) and eigenvalues'
            Color = 16578805
            Padding.Left = 8
            Padding.Top = 32
            Padding.Right = 8
            Padding.Bottom = 8
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            ExplicitWidth = 529
            ExplicitHeight = 323
            object redP1Result: TRichEdit
              Left = 8
              Top = 32
              Width = 514
              Height = 287
              Align = alClient
              BorderStyle = bsNone
              Color = 16578805
              Font.Charset = ANSI_CHARSET
              Font.Color = 3682854
              Font.Height = -11
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              PlainText = True
              ReadOnly = True
              ScrollBars = ssBoth
              TabOrder = 0
              WordWrap = False
              ExplicitWidth = 513
              ExplicitHeight = 283
            end
          end
          object chtP1Poles: TChart
            Left = 536
            Top = 0
            Width = 536
            Height = 333
            BackWall.Brush.Style = bsClear
            Legend.Alignment = laBottom
            Legend.CheckBoxes = True
            Legend.Font.Color = 3355443
            Legend.Font.Height = -11
            Legend.Font.Name = 'Segoe UI'
            Legend.Frame.Visible = False
            Legend.LegendStyle = lsSeries
            Title.Font.Color = 10569485
            Title.Font.Name = 'Segoe UI'
            Title.Font.Style = [fsBold]
            Title.Text.Strings = (
              'Eigenvalues of Ad and the unit circle |z| = 1')
            BottomAxis.Grid.Color = 15132390
            BottomAxis.LabelsFormat.Font.Color = 5592405
            BottomAxis.LabelsFormat.Font.Height = -11
            BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
            BottomAxis.Title.Caption = 'Re z (-)'
            BottomAxis.Title.Font.Color = 3355443
            BottomAxis.Title.Font.Height = -12
            BottomAxis.Title.Font.Name = 'Segoe UI'
            LeftAxis.Grid.Color = 15132390
            LeftAxis.LabelsFormat.Font.Color = 5592405
            LeftAxis.LabelsFormat.Font.Height = -11
            LeftAxis.LabelsFormat.Font.Name = 'Segoe UI'
            LeftAxis.Title.Caption = 'Im z (-)'
            LeftAxis.Title.Font.Color = 3355443
            LeftAxis.Title.Font.Height = -12
            LeftAxis.Title.Font.Name = 'Segoe UI'
            View3D = False
            OnAfterDraw = ChartAfterDraw
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 1
            OnDblClick = ChartDblClick
            ExplicitLeft = 535
            ExplicitWidth = 535
            ExplicitHeight = 329
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            object serP1Circle: TLineSeries
              SeriesColor = 9868950
              Title = 'Unit circle |z| = 1'
              Brush.BackColor = clDefault
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              XValues.Name = 'X'
              XValues.Order = loNone
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serP1Poles: TPointSeries
              SeriesColor = 24277
              Title = 'Eigenvalues of Ad'
              ClickableLine = False
              Pointer.HorizSize = 4
              Pointer.InflateMargins = True
              Pointer.Pen.Visible = False
              Pointer.Style = psCircle
              Pointer.VertSize = 4
              XValues.Name = 'X'
              XValues.Order = loNone
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
          object chtP1Step: TChart
            Left = 0
            Top = 333
            Width = 536
            Height = 333
            BackWall.Brush.Style = bsClear
            Legend.Alignment = laBottom
            Legend.CheckBoxes = True
            Legend.Font.Color = 3355443
            Legend.Font.Height = -11
            Legend.Font.Name = 'Segoe UI'
            Legend.Frame.Visible = False
            Legend.LegendStyle = lsSeries
            Title.Font.Color = 10569485
            Title.Font.Name = 'Segoe UI'
            Title.Font.Style = [fsBold]
            Title.Text.Strings = (
              'Step response y(k)')
            BottomAxis.Grid.Color = 15132390
            BottomAxis.LabelsFormat.Font.Color = 5592405
            BottomAxis.LabelsFormat.Font.Height = -11
            BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
            BottomAxis.Title.Caption = 't = kT (s)'
            BottomAxis.Title.Font.Color = 3355443
            BottomAxis.Title.Font.Height = -12
            BottomAxis.Title.Font.Name = 'Segoe UI'
            LeftAxis.Grid.Color = 15132390
            LeftAxis.LabelsFormat.Font.Color = 5592405
            LeftAxis.LabelsFormat.Font.Height = -11
            LeftAxis.LabelsFormat.Font.Name = 'Segoe UI'
            LeftAxis.Title.Caption = 'y (-)'
            LeftAxis.Title.Font.Color = 3355443
            LeftAxis.Title.Font.Height = -12
            LeftAxis.Title.Font.Name = 'Segoe UI'
            View3D = False
            OnAfterDraw = ChartAfterDraw
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 2
            OnDblClick = ChartDblClick
            ExplicitTop = 329
            ExplicitWidth = 535
            ExplicitHeight = 329
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            object serP1Step: TFastLineSeries
              SeriesColor = 11694592
              Title = 'Discrete model y(k)'
              LinePen.Color = 11694592
              LinePen.Width = 3
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serP1StepExact: TFastLineSeries
              SeriesColor = 40934
              Title = 'Exact continuous y(t) at t = kT'
              LinePen.Color = 40934
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
          object chtP1Imp: TChart
            Left = 536
            Top = 333
            Width = 536
            Height = 333
            BackWall.Brush.Style = bsClear
            Legend.Alignment = laBottom
            Legend.CheckBoxes = True
            Legend.Font.Color = 3355443
            Legend.Font.Height = -11
            Legend.Font.Name = 'Segoe UI'
            Legend.Frame.Visible = False
            Legend.LegendStyle = lsSeries
            Title.Font.Color = 10569485
            Title.Font.Name = 'Segoe UI'
            Title.Font.Style = [fsBold]
            Title.Text.Strings = (
              'Impulse response: pulse u(0) = 1/T (area 1)')
            BottomAxis.Grid.Color = 15132390
            BottomAxis.LabelsFormat.Font.Color = 5592405
            BottomAxis.LabelsFormat.Font.Height = -11
            BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
            BottomAxis.Title.Caption = 't = kT (s)'
            BottomAxis.Title.Font.Color = 3355443
            BottomAxis.Title.Font.Height = -12
            BottomAxis.Title.Font.Name = 'Segoe UI'
            LeftAxis.Grid.Color = 15132390
            LeftAxis.LabelsFormat.Font.Color = 5592405
            LeftAxis.LabelsFormat.Font.Height = -11
            LeftAxis.LabelsFormat.Font.Name = 'Segoe UI'
            LeftAxis.Title.Caption = 'y (-)'
            LeftAxis.Title.Font.Color = 3355443
            LeftAxis.Title.Font.Height = -12
            LeftAxis.Title.Font.Name = 'Segoe UI'
            View3D = False
            OnAfterDraw = ChartAfterDraw
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 3
            OnDblClick = ChartDblClick
            ExplicitLeft = 535
            ExplicitTop = 329
            ExplicitWidth = 535
            ExplicitHeight = 329
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            object serP1Imp: TFastLineSeries
              SeriesColor = 11694592
              Title = 'Discrete model y(k)'
              LinePen.Color = 11694592
              LinePen.Width = 3
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serP1ImpExact: TFastLineSeries
              SeriesColor = 40934
              Title = 'Exact continuous g(t) at t = kT'
              LinePen.Color = 40934
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
        end
      end
    end
    object tsP2: TTabSheet
      Caption = 'Problem 2: Ho-Kalman Realisation (SVD)'
      object pnlP2Bg: TPanel
        Left = 0
        Top = 0
        Width = 1392
        Height = 666
        Align = alClient
        BevelOuter = bvNone
        Color = 16117996
        ParentBackground = False
        TabOrder = 0
        object pnlP2Side: TPanel
          Left = 0
          Top = 0
          Width = 320
          Height = 666
          Align = alLeft
          BevelOuter = bvNone
          Color = 16117996
          Padding.Left = 6
          Padding.Top = 6
          Padding.Right = 6
          Padding.Bottom = 6
          ParentBackground = False
          TabOrder = 0
          object cardP2Plant: TPanel
            Tag = 12
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 308
            Height = 116
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Plant x'#39#39' = -a1 x'#39' - a0 x + b0 u (editable)'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            object vleP2Plant: TValueListEditor
              Left = 8
              Top = 32
              Width = 292
              Height = 76
              Hint = 'The sheet: x'#39#39' = -0.5 x'#39' - x + u, output y = x'
              ParentShowHint = False
              ShowHint = True
              Strings.Strings = (
                'a1 (damping term)=0.5'
                'a0 (stiffness term)=1'
                'b0 (input gain)=1')
              TabOrder = 0
              TitleCaptions.Strings = (
                'Parameter'
                'Value')
              ColWidths = (
                150
                138)
            end
          end
          object cardP2Data: TPanel
            Tag = 12
            AlignWithMargins = True
            Left = 6
            Top = 128
            Width = 308
            Height = 180
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Discrete step data (editable)'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 1
            object vleP2Data: TValueListEditor
              Left = 8
              Top = 32
              Width = 292
              Height = 58
              Hint = 
                'The sheet uses an interval of 0.1 s. The Hankel matrices need at' +
                ' least k + l + 1 samples.'
              ParentShowHint = False
              ShowHint = True
              Strings.Strings = (
                'Sampling interval T (s)=0.1'
                'Number of step samples=40')
              TabOrder = 0
              TitleCaptions.Strings = (
                'Parameter'
                'Value')
              ColWidths = (
                150
                138)
            end
            object rgP2Source: TRadioGroup
              Left = 8
              Top = 94
              Width = 292
              Height = 78
              Color = 16578805
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ItemIndex = 0
              Items.Strings = (
                'Lecture bilinear (formula of Problem 1)'
                'Standard bilinear'
                'Zero-order hold (exact samples)')
              ParentBackground = False
              ParentColor = False
              ParentFont = False
              TabOrder = 1
            end
          end
          object cardP2Hankel: TPanel
            Tag = 12
            AlignWithMargins = True
            Left = 6
            Top = 314
            Width = 308
            Height = 134
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Hankel matrix and model order (editable)'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 2
            object vleP2Hankel: TValueListEditor
              Left = 8
              Top = 32
              Width = 292
              Height = 96
              Hint = 
                'k = l = 4 reproduces the lecturer data and the plant of Problem ' +
                '3. n = 0 counts the singular values above the tolerance.'
              ParentShowHint = False
              ShowHint = True
              Strings.Strings = (
                'Hankel rows k=4'
                'Hankel columns l=4'
                'Model order n (0 for automatic)=0'
                'Order tolerance sigma_i / sigma_1=1E-8')
              TabOrder = 0
              TitleCaptions.Strings = (
                'Parameter'
                'Value')
              ColWidths = (
                186
                102)
            end
          end
          object cardP2Run: TPanel
            Tag = 10
            AlignWithMargins = True
            Left = 6
            Top = 454
            Width = 308
            Height = 110
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Compute'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 3
            object btnP2Data: TPanel
              Tag = 6
              Left = 12
              Top = 34
              Width = 140
              Height = 32
              Cursor = crHandPoint
              Hint = 
                'Step data S(k) and Markov parameters g(k) (Equations 1.9 and 1.1' +
                '0)'
              BevelOuter = bvNone
              Caption = 'Generate step data'
              Color = 12608789
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = btnP2DataClick
            end
            object btnP2Identify: TPanel
              Tag = 1
              Left = 160
              Top = 34
              Width = 140
              Height = 32
              Cursor = crHandPoint
              Hint = 'Hankel matrix, SVD and A, B, C, D (Equations 1.11 to 1.16)'
              BevelOuter = bvNone
              Caption = 'Ho-Kalman (SVD)'
              Color = 12608789
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnClick = btnP2IdentifyClick
            end
            object btnP2Save: TPanel
              Tag = 4
              Left = 12
              Top = 72
              Width = 140
              Height = 30
              Cursor = crHandPoint
              Hint = 'Save every process step and the model as a text file'
              BevelOuter = bvNone
              Caption = 'Save .dat file'
              Color = 12608789
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              OnClick = btnP2SaveClick
            end
            object btnP2ToObserver: TPanel
              Tag = 8
              Left = 160
              Top = 72
              Width = 140
              Height = 30
              Cursor = crHandPoint
              Hint = 'Take the identified model as the plant of Problem 3'
              BevelOuter = bvNone
              Caption = 'Use in Problem 3'
              Color = 12608789
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
              OnClick = btnP2ToObserverClick
            end
          end
        end
        object gpP2: TGridPanel
          Left = 320
          Top = 0
          Width = 1072
          Height = 666
          Align = alClient
          BevelOuter = bvNone
          ColumnCollection = <
            item
              Value = 50.000000000000000000
            end
            item
              Value = 50.000000000000000000
            end>
          ControlCollection = <
            item
              Column = 0
              Control = chtP2Step
              Row = 0
            end
            item
              Column = 1
              Control = chtP2Markov
              Row = 0
            end
            item
              Column = 0
              Control = chtP2Sigma
              Row = 1
            end
            item
              Column = 1
              Control = cardP2Result
              Row = 1
            end>
          ParentBackground = False
          RowCollection = <
            item
              Value = 50.000000000000000000
            end
            item
              Value = 50.000000000000000000
            end>
          TabOrder = 1
          object chtP2Step: TChart
            Left = 0
            Top = 0
            Width = 536
            Height = 333
            BackWall.Brush.Style = bsClear
            Legend.Alignment = laBottom
            Legend.CheckBoxes = True
            Legend.Font.Color = 3355443
            Legend.Font.Height = -11
            Legend.Font.Name = 'Segoe UI'
            Legend.Frame.Visible = False
            Legend.LegendStyle = lsSeries
            Title.Font.Color = 10569485
            Title.Font.Name = 'Segoe UI'
            Title.Font.Style = [fsBold]
            Title.Text.Strings = (
              'Step data S(k) and the identified model')
            BottomAxis.Grid.Color = 15132390
            BottomAxis.LabelsFormat.Font.Color = 5592405
            BottomAxis.LabelsFormat.Font.Height = -11
            BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
            BottomAxis.Title.Caption = 't = kT (s)'
            BottomAxis.Title.Font.Color = 3355443
            BottomAxis.Title.Font.Height = -12
            BottomAxis.Title.Font.Name = 'Segoe UI'
            LeftAxis.Grid.Color = 15132390
            LeftAxis.LabelsFormat.Font.Color = 5592405
            LeftAxis.LabelsFormat.Font.Height = -11
            LeftAxis.LabelsFormat.Font.Name = 'Segoe UI'
            LeftAxis.Title.Caption = 'S (-)'
            LeftAxis.Title.Font.Color = 3355443
            LeftAxis.Title.Font.Height = -12
            LeftAxis.Title.Font.Name = 'Segoe UI'
            View3D = False
            OnAfterDraw = ChartAfterDraw
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 0
            OnDblClick = ChartDblClick
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            object serP2Data: TPointSeries
              SeriesColor = 11694592
              Title = 'Step data S(k)'
              ClickableLine = False
              Pointer.InflateMargins = True
              Pointer.Pen.Visible = False
              Pointer.Style = psCircle
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serP2Model: TLineSeries
              SeriesColor = 24277
              Title = 'Identified model'
              Brush.BackColor = clDefault
              LinePen.Width = 2
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
          object chtP2Markov: TChart
            Left = 536
            Top = 0
            Width = 536
            Height = 333
            BackWall.Brush.Style = bsClear
            Legend.Alignment = laBottom
            Legend.CheckBoxes = True
            Legend.Font.Color = 3355443
            Legend.Font.Height = -11
            Legend.Font.Name = 'Segoe UI'
            Legend.Frame.Visible = False
            Legend.LegendStyle = lsSeries
            Title.Font.Color = 10569485
            Title.Font.Name = 'Segoe UI'
            Title.Font.Style = [fsBold]
            Title.Text.Strings = (
              'Markov parameters g(k) = S(k) - S(k-1)')
            BottomAxis.Grid.Color = 15132390
            BottomAxis.LabelsFormat.Font.Color = 5592405
            BottomAxis.LabelsFormat.Font.Height = -11
            BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
            BottomAxis.Title.Caption = 'k (-)'
            BottomAxis.Title.Font.Color = 3355443
            BottomAxis.Title.Font.Height = -12
            BottomAxis.Title.Font.Name = 'Segoe UI'
            LeftAxis.Grid.Color = 15132390
            LeftAxis.LabelsFormat.Font.Color = 5592405
            LeftAxis.LabelsFormat.Font.Height = -11
            LeftAxis.LabelsFormat.Font.Name = 'Segoe UI'
            LeftAxis.Title.Caption = 'g (-)'
            LeftAxis.Title.Font.Color = 3355443
            LeftAxis.Title.Font.Height = -12
            LeftAxis.Title.Font.Name = 'Segoe UI'
            View3D = False
            OnAfterDraw = ChartAfterDraw
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 1
            OnDblClick = ChartDblClick
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            object serP2Markov: TPointSeries
              SeriesColor = 7577088
              Title = 'g(k) from the data'
              ClickableLine = False
              Pointer.InflateMargins = True
              Pointer.Pen.Visible = False
              Pointer.Style = psRectangle
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serP2MarkovModel: TLineSeries
              SeriesColor = 10975692
              Title = 'C A^(k-1) B of the model'
              Brush.BackColor = clDefault
              LinePen.Width = 2
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
          object chtP2Sigma: TChart
            Left = 0
            Top = 333
            Width = 536
            Height = 333
            BackWall.Brush.Style = bsClear
            Legend.Alignment = laBottom
            Legend.CheckBoxes = True
            Legend.Font.Color = 3355443
            Legend.Font.Height = -11
            Legend.Font.Name = 'Segoe UI'
            Legend.Frame.Visible = False
            Legend.LegendStyle = lsSeries
            Title.Font.Color = 10569485
            Title.Font.Name = 'Segoe UI'
            Title.Font.Style = [fsBold]
            Title.Text.Strings = (
              'Singular values of the Hankel matrix, log10 sigma_i')
            BottomAxis.Grid.Color = 15132390
            BottomAxis.LabelsFormat.Font.Color = 5592405
            BottomAxis.LabelsFormat.Font.Height = -11
            BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
            BottomAxis.Title.Caption = 'i (-)'
            BottomAxis.Title.Font.Color = 3355443
            BottomAxis.Title.Font.Height = -12
            BottomAxis.Title.Font.Name = 'Segoe UI'
            LeftAxis.Grid.Color = 15132390
            LeftAxis.LabelsFormat.Font.Color = 5592405
            LeftAxis.LabelsFormat.Font.Height = -11
            LeftAxis.LabelsFormat.Font.Name = 'Segoe UI'
            LeftAxis.Title.Caption = 'log10 sigma (-)'
            LeftAxis.Title.Font.Color = 3355443
            LeftAxis.Title.Font.Height = -12
            LeftAxis.Title.Font.Name = 'Segoe UI'
            View3D = False
            OnAfterDraw = ChartAfterDraw
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 2
            OnDblClick = ChartDblClick
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            object serP2Sigma: TLineSeries
              SeriesColor = 11694592
              Title = 'log10 sigma_i'
              Brush.BackColor = clDefault
              LinePen.Width = 2
              Pointer.HorizSize = 5
              Pointer.InflateMargins = True
              Pointer.Pen.Visible = False
              Pointer.Style = psCircle
              Pointer.VertSize = 5
              Pointer.Visible = True
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serP2Tol: TLineSeries
              SeriesColor = 24277
              Title = 'Order threshold log10(tol x sigma_1)'
              Brush.BackColor = clDefault
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
          object cardP2Result: TPanel
            Tag = 14
            AlignWithMargins = True
            Left = 539
            Top = 336
            Width = 530
            Height = 327
            Align = alClient
            BevelOuter = bvNone
            Caption = 'Process data and model A, B, C, D'
            Color = 16578805
            Padding.Left = 8
            Padding.Top = 32
            Padding.Right = 8
            Padding.Bottom = 8
            ParentBackground = False
            ShowCaption = False
            TabOrder = 3
            object redP2Result: TRichEdit
              Left = 8
              Top = 32
              Width = 514
              Height = 287
              Align = alClient
              BorderStyle = bsNone
              Color = 16578805
              Font.Charset = ANSI_CHARSET
              Font.Color = 3682854
              Font.Height = -11
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              PlainText = True
              ReadOnly = True
              ScrollBars = ssBoth
              TabOrder = 0
              WordWrap = False
            end
          end
        end
      end
    end
    object tsP3: TTabSheet
      Caption = 'Problem 3: Observer Gain (Pole Placement)'
      object pnlP3Bg: TPanel
        Left = 0
        Top = 0
        Width = 1392
        Height = 666
        Align = alClient
        BevelOuter = bvNone
        Color = 16117996
        ParentBackground = False
        TabOrder = 0
        object pnlP3Side: TPanel
          Left = 0
          Top = 0
          Width = 320
          Height = 666
          Align = alLeft
          BevelOuter = bvNone
          Color = 16117996
          Padding.Left = 6
          Padding.Top = 6
          Padding.Right = 6
          Padding.Bottom = 6
          ParentBackground = False
          TabOrder = 0
          object cardP3Preset: TPanel
            Tag = 10
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 308
            Height = 112
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Plant'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            object rgP3Preset: TRadioGroup
              Left = 8
              Top = 30
              Width = 292
              Height = 76
              Color = 16578805
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ItemIndex = 0
              Items.Strings = (
                'Problem 3 plant (sheet)'
                'Ho-Kalman model from Problem 2'
                'Lecture slides example (pendulum, p. 26)')
              ParentBackground = False
              ParentColor = False
              ParentFont = False
              TabOrder = 0
              OnClick = rgP3PresetClick
            end
          end
          object cardP3Plant: TPanel
            Tag = 12
            AlignWithMargins = True
            Left = 6
            Top = 124
            Width = 308
            Height = 172
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Discrete plant and observer poles (editable)'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 1
            object vleP3Plant: TValueListEditor
              Left = 8
              Top = 32
              Width = 292
              Height = 134
              Hint = 
                'det(lambda I - (A - Kob C)) = (lambda - p1)(lambda - p2) (Equati' +
                'on 1.19)'
              ParentShowHint = False
              ShowHint = True
              Strings.Strings = (
                'A row 1=1.201 -0.249'
                'A row 2=0.249 0.74'
                'B (column, top to bottom)=-0.115 0.09'
                'C=-0.115 -0.09'
                'Observer pole p1=0.8'
                'Observer pole p2=0.7')
              TabOrder = 0
              TitleCaptions.Strings = (
                'Parameter'
                'Value')
              ColWidths = (
                150
                138)
            end
          end
          object cardP3Sim: TPanel
            Tag = 12
            AlignWithMargins = True
            Left = 6
            Top = 302
            Width = 308
            Height = 134
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Observer simulation (editable)'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 2
            object vleP3Sim: TValueListEditor
              Left = 8
              Top = 32
              Width = 292
              Height = 96
              Hint = 
                'The open-loop model starts from the same guess as the observer (' +
                'Equations 1.17 and 1.18)'
              ParentShowHint = False
              ShowHint = True
              Strings.Strings = (
                'Plant start x(0)=1 0'
                'Observer start x^(0)=0 0'
                'Input u(k) (constant)=1'
                'Number of samples=40')
              TabOrder = 0
              TitleCaptions.Strings = (
                'Parameter'
                'Value')
              ColWidths = (
                150
                138)
            end
          end
          object cardP3Run: TPanel
            Tag = 10
            AlignWithMargins = True
            Left = 6
            Top = 442
            Width = 308
            Height = 76
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Compute'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 3
            object btnP3Gain: TPanel
              Tag = 8
              Left = 12
              Top = 34
              Width = 140
              Height = 32
              Cursor = crHandPoint
              Hint = 'Observer gain by pole placement (Equations 2.7 and 2.8)'
              BevelOuter = bvNone
              Caption = 'Compute Kob'
              Color = 12608789
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = btnP3GainClick
            end
            object btnP3Simulate: TPanel
              Tag = 8
              Left = 160
              Top = 34
              Width = 140
              Height = 32
              Cursor = crHandPoint
              Hint = 'Plant, observer and open-loop model from different start states'
              BevelOuter = bvNone
              Caption = 'Simulate observer'
              Color = 12608789
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnClick = btnP3SimulateClick
            end
          end
        end
        object gpP3: TGridPanel
          Left = 320
          Top = 0
          Width = 1072
          Height = 666
          Align = alClient
          BevelOuter = bvNone
          ColumnCollection = <
            item
              Value = 50.000000000000000000
            end
            item
              Value = 50.000000000000000000
            end>
          ControlCollection = <
            item
              Column = 0
              Control = cardP3Result
              Row = 0
            end
            item
              Column = 1
              Control = chtP3Err
              Row = 0
            end
            item
              Column = 0
              Control = chtP3X1
              Row = 1
            end
            item
              Column = 1
              Control = chtP3X2
              Row = 1
            end>
          ParentBackground = False
          RowCollection = <
            item
              Value = 50.000000000000000000
            end
            item
              Value = 50.000000000000000000
            end>
          TabOrder = 1
          object cardP3Result: TPanel
            Tag = 14
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 530
            Height = 327
            Align = alClient
            BevelOuter = bvNone
            Caption = 'Observer gain Kob and error poles'
            Color = 16578805
            Padding.Left = 8
            Padding.Top = 32
            Padding.Right = 8
            Padding.Bottom = 8
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            object redP3Result: TRichEdit
              Left = 8
              Top = 32
              Width = 514
              Height = 287
              Align = alClient
              BorderStyle = bsNone
              Color = 16578805
              Font.Charset = ANSI_CHARSET
              Font.Color = 3682854
              Font.Height = -11
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              PlainText = True
              ReadOnly = True
              ScrollBars = ssBoth
              TabOrder = 0
              WordWrap = False
            end
          end
          object chtP3Err: TChart
            Left = 536
            Top = 0
            Width = 536
            Height = 333
            BackWall.Brush.Style = bsClear
            Legend.Alignment = laBottom
            Legend.CheckBoxes = True
            Legend.Font.Color = 3355443
            Legend.Font.Height = -11
            Legend.Font.Name = 'Segoe UI'
            Legend.Frame.Visible = False
            Legend.LegendStyle = lsSeries
            Title.Font.Color = 10569485
            Title.Font.Name = 'Segoe UI'
            Title.Font.Style = [fsBold]
            Title.Text.Strings = (
              'Estimation error |x(k) - x^(k)|')
            BottomAxis.Grid.Color = 15132390
            BottomAxis.LabelsFormat.Font.Color = 5592405
            BottomAxis.LabelsFormat.Font.Height = -11
            BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
            BottomAxis.Title.Caption = 'k (-)'
            BottomAxis.Title.Font.Color = 3355443
            BottomAxis.Title.Font.Height = -12
            BottomAxis.Title.Font.Name = 'Segoe UI'
            LeftAxis.Grid.Color = 15132390
            LeftAxis.LabelsFormat.Font.Color = 5592405
            LeftAxis.LabelsFormat.Font.Height = -11
            LeftAxis.LabelsFormat.Font.Name = 'Segoe UI'
            LeftAxis.Title.Caption = '|error| (-)'
            LeftAxis.Title.Font.Color = 3355443
            LeftAxis.Title.Font.Height = -12
            LeftAxis.Title.Font.Name = 'Segoe UI'
            View3D = False
            OnAfterDraw = ChartAfterDraw
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 1
            OnDblClick = ChartDblClick
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            object serP3ErrObs: TLineSeries
              SeriesColor = 11694592
              Title = 'Observer (poles p1, p2)'
              Brush.BackColor = clDefault
              LinePen.Width = 2
              Pointer.HorizSize = 3
              Pointer.InflateMargins = True
              Pointer.Pen.Visible = False
              Pointer.Style = psCircle
              Pointer.VertSize = 3
              Pointer.Visible = True
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serP3ErrOpen: TLineSeries
              SeriesColor = 24277
              Title = 'Open-loop model (poles of A)'
              Brush.BackColor = clDefault
              LinePen.Width = 2
              Pointer.HorizSize = 3
              Pointer.InflateMargins = True
              Pointer.Pen.Visible = False
              Pointer.Style = psRectangle
              Pointer.VertSize = 3
              Pointer.Visible = True
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
          object chtP3X1: TChart
            Left = 0
            Top = 333
            Width = 536
            Height = 333
            BackWall.Brush.Style = bsClear
            Legend.Alignment = laBottom
            Legend.CheckBoxes = True
            Legend.Font.Color = 3355443
            Legend.Font.Height = -11
            Legend.Font.Name = 'Segoe UI'
            Legend.Frame.Visible = False
            Legend.LegendStyle = lsSeries
            Title.Font.Color = 10569485
            Title.Font.Name = 'Segoe UI'
            Title.Font.Style = [fsBold]
            Title.Text.Strings = (
              'State x1(k)')
            BottomAxis.Grid.Color = 15132390
            BottomAxis.LabelsFormat.Font.Color = 5592405
            BottomAxis.LabelsFormat.Font.Height = -11
            BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
            BottomAxis.Title.Caption = 'k (-)'
            BottomAxis.Title.Font.Color = 3355443
            BottomAxis.Title.Font.Height = -12
            BottomAxis.Title.Font.Name = 'Segoe UI'
            LeftAxis.Grid.Color = 15132390
            LeftAxis.LabelsFormat.Font.Color = 5592405
            LeftAxis.LabelsFormat.Font.Height = -11
            LeftAxis.LabelsFormat.Font.Name = 'Segoe UI'
            LeftAxis.Title.Caption = 'x1 (-)'
            LeftAxis.Title.Font.Color = 3355443
            LeftAxis.Title.Font.Height = -12
            LeftAxis.Title.Font.Name = 'Segoe UI'
            View3D = False
            OnAfterDraw = ChartAfterDraw
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 2
            OnDblClick = ChartDblClick
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            object serP3X1: TLineSeries
              SeriesColor = clBlack
              Title = 'Plant x1'
              Brush.BackColor = clDefault
              LinePen.Width = 2
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serP3Xo1: TLineSeries
              SeriesColor = 11694592
              Title = 'Observer estimate'
              Brush.BackColor = clDefault
              LinePen.Width = 2
              Pointer.HorizSize = 3
              Pointer.InflateMargins = True
              Pointer.Pen.Visible = False
              Pointer.Style = psCircle
              Pointer.VertSize = 3
              Pointer.Visible = True
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serP3Xm1: TLineSeries
              SeriesColor = 40934
              Title = 'Open-loop model'
              Brush.BackColor = clDefault
              LinePen.Width = 2
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
          object chtP3X2: TChart
            Left = 536
            Top = 333
            Width = 536
            Height = 333
            BackWall.Brush.Style = bsClear
            Legend.Alignment = laBottom
            Legend.CheckBoxes = True
            Legend.Font.Color = 3355443
            Legend.Font.Height = -11
            Legend.Font.Name = 'Segoe UI'
            Legend.Frame.Visible = False
            Legend.LegendStyle = lsSeries
            Title.Font.Color = 10569485
            Title.Font.Name = 'Segoe UI'
            Title.Font.Style = [fsBold]
            Title.Text.Strings = (
              'State x2(k)')
            BottomAxis.Grid.Color = 15132390
            BottomAxis.LabelsFormat.Font.Color = 5592405
            BottomAxis.LabelsFormat.Font.Height = -11
            BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
            BottomAxis.Title.Caption = 'k (-)'
            BottomAxis.Title.Font.Color = 3355443
            BottomAxis.Title.Font.Height = -12
            BottomAxis.Title.Font.Name = 'Segoe UI'
            LeftAxis.Grid.Color = 15132390
            LeftAxis.LabelsFormat.Font.Color = 5592405
            LeftAxis.LabelsFormat.Font.Height = -11
            LeftAxis.LabelsFormat.Font.Name = 'Segoe UI'
            LeftAxis.Title.Caption = 'x2 (-)'
            LeftAxis.Title.Font.Color = 3355443
            LeftAxis.Title.Font.Height = -12
            LeftAxis.Title.Font.Name = 'Segoe UI'
            View3D = False
            OnAfterDraw = ChartAfterDraw
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 3
            OnDblClick = ChartDblClick
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            object serP3X2: TLineSeries
              SeriesColor = clBlack
              Title = 'Plant x2'
              Brush.BackColor = clDefault
              LinePen.Width = 2
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serP3Xo2: TLineSeries
              SeriesColor = 11694592
              Title = 'Observer estimate'
              Brush.BackColor = clDefault
              LinePen.Width = 2
              Pointer.HorizSize = 3
              Pointer.InflateMargins = True
              Pointer.Pen.Visible = False
              Pointer.Style = psCircle
              Pointer.VertSize = 3
              Pointer.Visible = True
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serP3Xm2: TLineSeries
              SeriesColor = 40934
              Title = 'Open-loop model'
              Brush.BackColor = clDefault
              LinePen.Width = 2
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
        end
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 860
    Width = 1400
    Height = 20
    Panels = <
      item
        Width = 1000
      end
      item
        Width = 50
      end>
    ExplicitTop = 852
    ExplicitWidth = 1398
  end
  object SaveDialogCSV: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'CSV files (*.csv)|*.csv|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 1144
    Top = 8
  end
  object SaveDialogPNG: TSaveDialog
    DefaultExt = 'png'
    Filter = 'PNG images (*.png)|*.png|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 1232
    Top = 8
  end
  object SaveDialogDAT: TSaveDialog
    DefaultExt = 'dat'
    Filter = 'Data files (*.dat)|*.dat|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 1320
    Top = 8
  end
end
