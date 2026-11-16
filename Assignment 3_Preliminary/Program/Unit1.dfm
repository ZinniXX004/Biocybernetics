object Form1: TForm1
  Left = 0
  Top = 0
  Caption =
    'Jeremia Christ Immanuel Manalu - 5023231017 - Ziegler-Nichols PI' +
    'D Parameter Determination (Plant 1 and Plant 2)'
  ClientHeight = 860
  ClientWidth = 1400
  Color = 16117996
  Constraints.MinHeight = 720
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
    Tag = 11
    object lblTitle: TLabel
      Left = 18
      Top = 6
      Width = 600
      Height = 32
      Caption = 'Ziegler-Nichols PID Parameter Determination'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -24
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object lblSubtitle: TLabel
      Left = 18
      Top = 40
      Width = 600
      Height = 15
      Caption = 'Jeremia Christ Immanuel Manalu (5023231017)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object btnEquations: TPanel
      Left = 822
      Top = 14
      Width = 120
      Height = 36
      Anchors = [akTop, akRight]
      BevelOuter = bvNone
      Caption = 'Equations (F1)'
      Color = 12608789
      Cursor = crHandPoint
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Hint = 'Show the equations used by the program'
      TabOrder = 0
      Tag = 5
      OnClick = btnEquationsClick
    end
    object btnExportCSV: TPanel
      Left = 950
      Top = 14
      Width = 110
      Height = 36
      Anchors = [akTop, akRight]
      BevelOuter = bvNone
      Caption = 'Export CSV'
      Color = 12608789
      Cursor = crHandPoint
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Hint = 'Save the data of the charts on the active tab'
      TabOrder = 1
      Tag = 4
      OnClick = btnExportCSVClick
    end
    object btnExportPNG: TPanel
      Left = 1068
      Top = 14
      Width = 110
      Height = 36
      Anchors = [akTop, akRight]
      BevelOuter = bvNone
      Caption = 'Export PNG'
      Color = 12608789
      Cursor = crHandPoint
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Hint = 'Save the charts of the active tab as an image'
      TabOrder = 2
      Tag = 4
      OnClick = btnExportPNGClick
    end
    object btnClear: TPanel
      Left = 1186
      Top = 14
      Width = 100
      Height = 36
      Anchors = [akTop, akRight]
      BevelOuter = bvNone
      Caption = 'CLEAR'
      Color = 12608789
      Cursor = crHandPoint
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Hint = 'Clear every output, chart and message'
      TabOrder = 3
      Tag = 6
      OnClick = btnClearClick
    end
    object btnExit: TPanel
      Left = 1294
      Top = 14
      Width = 90
      Height = 36
      Anchors = [akTop, akRight]
      BevelOuter = bvNone
      Caption = 'EXIT'
      Color = 12608789
      Cursor = crHandPoint
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Hint = 'Close the program'
      TabOrder = 4
      Tag = 3
      OnClick = btnExitClick
    end
  end
  object pnlSettings: TPanel
    Left = 0
    Top = 64
    Width = 280
    Height = 776
    Align = alLeft
    BevelOuter = bvNone
    Color = 16117996
    Padding.Left = 8
    Padding.Top = 8
    Padding.Right = 0
    Padding.Bottom = 8
    ParentBackground = False
    TabOrder = 1
    object cardSettings: TPanel
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 272
      Height = 236
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Simulation settings (editable)'
      Color = 16578805
      ParentBackground = False
      ShowCaption = False
      TabOrder = 0
      Tag = 12
      object vleParams: TValueListEditor
        Left = 8
        Top = 32
        Width = 256
        Height = 128
        Strings.Strings = (
          'Time step dt (s)=0.001'
          'Simulation time (s)=30'
          'Dead time theta (s)=0.1'
          'Step amplitude x0 (-)=1'
          'Setpoint r (-)=1')
        TabOrder = 0
        TitleCaptions.Strings = (
          'Parameter'
          'Value')
        ColWidths = (
          160
          90)
      end
      object lblSettingsNote: TLabel
        Left = 8
        Top = 166
        Width = 256
        Height = 60
        AutoSize = False
        Caption =
          'theta = 0 gives the plants of the problem sheet; theta >' +
          ' 0 is the dead time that ZN needs (report Section 2.2.6)' +
          '.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 3682854
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
      end
    end
    object cardLog: TPanel
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 272
      Height = 300
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Messages and warnings'
      Color = 15924223
      Padding.Left = 8
      Padding.Top = 32
      Padding.Right = 8
      Padding.Bottom = 8
      ParentBackground = False
      ShowCaption = False
      TabOrder = 1
      Tag = 13
      object redLog: TRichEdit
        Left = 8
        Top = 32
        Width = 256
        Height = 200
        Align = alClient
        BorderStyle = bsNone
        Color = 15924223
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 3682854
        Font.Height = -11
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object PageControl1: TPageControl
    Left = 280
    Top = 64
    Width = 1120
    Height = 776
    ActivePage = tsPlant
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object tsPlant: TTabSheet
      Caption = 'Plant Model and RK4 (Problems 1, 2)'
      object pnlPlantBg: TPanel
        Left = 0
        Top = 0
        Width = 1100
        Height = 740
        Align = alClient
        BevelOuter = bvNone
        Color = 16117996
        ParentBackground = False
        TabOrder = 0
        object pnlPlantSide: TPanel
          Left = 0
          Top = 0
          Width = 300
          Height = 740
          Align = alLeft
          BevelOuter = bvNone
          Color = 16117996
          Padding.Left = 6
          Padding.Top = 6
          Padding.Right = 6
          Padding.Bottom = 6
          ParentBackground = False
          TabOrder = 0
          object cardImpulse: TPanel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 288
            Height = 80
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Impulse Response'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            Tag = 10
            object btnImpulse1: TPanel
              Left = 12
              Top = 36
              Width = 128
              Height = 34
              BevelOuter = bvNone
              Caption = 'Plant 1'
              Color = 12608789
              Cursor = crHandPoint
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Impulse response of plant 1 (RK4)'
              TabOrder = 0
              Tag = 1
              OnClick = btnImpulse1Click
            end
            object btnImpulse2: TPanel
              Left = 148
              Top = 36
              Width = 128
              Height = 34
              BevelOuter = bvNone
              Caption = 'Plant 2'
              Color = 12608789
              Cursor = crHandPoint
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Impulse response of plant 2 (RK4)'
              TabOrder = 0
              Tag = 1
              OnClick = btnImpulse2Click
            end
          end
          object cardStep: TPanel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 288
            Height = 80
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Step Response'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            Tag = 10
            object btnStep1: TPanel
              Left = 12
              Top = 36
              Width = 128
              Height = 34
              BevelOuter = bvNone
              Caption = 'Plant 1'
              Color = 12608789
              Cursor = crHandPoint
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Step response of plant 1 with the tangent'
              TabOrder = 0
              Tag = 1
              OnClick = btnStep1Click
            end
            object btnStep2: TPanel
              Left = 148
              Top = 36
              Width = 128
              Height = 34
              BevelOuter = bvNone
              Caption = 'Plant 2'
              Color = 12608789
              Cursor = crHandPoint
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Step response of plant 2 with the tangent'
              TabOrder = 0
              Tag = 1
              OnClick = btnStep2Click
            end
          end
          object cardModel: TPanel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 288
            Height = 210
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Parameter (from the last step response)'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            Tag = 14
            object lblR: TLabel
              Left = 12
              Top = 38
              Width = 170
              Height = 15
              Caption = 'R (max slope, 1/s)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtR: TEdit
              Left = 176
              Top = 34
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Largest slope of the step response'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
            object lblL: TLabel
              Left = 12
              Top = 66
              Width = 170
              Height = 15
              Caption = 'L (apparent dead time, s)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtL: TEdit
              Left = 176
              Top = 62
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Tangent crossing of y = 0'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
            object lblT: TLabel
              Left = 12
              Top = 94
              Width = 170
              Height = 15
              Caption = 'T (time constant, s)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtT: TEdit
              Left = 176
              Top = 90
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'T = K / R'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
            object lblK: TLabel
              Left = 12
              Top = 122
              Width = 170
              Height = 15
              Caption = 'K (static gain)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtK: TEdit
              Left = 176
              Top = 118
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Final value per unit step'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
            object lblMP: TLabel
              Left = 12
              Top = 150
              Width = 170
              Height = 15
              Caption = 'MP (peak value)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtMP: TEdit
              Left = 176
              Top = 146
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Largest output of the response'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
            object lblPMP: TLabel
              Left = 12
              Top = 178
              Width = 170
              Height = 15
              Caption = '%MP (overshoot, %)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtPMP: TEdit
              Left = 176
              Top = 174
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Overshoot of the step response'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
          end
          object cardPlantNote: TPanel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 288
            Height = 200
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alClient
            BevelOuter = bvNone
            Caption = 'How to read the chart'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            Tag = 15
            object lblPlantNote: TLabel
              Left = 12
              Top = 32
              Width = 264
              Height = 170
              AutoSize = False
              Caption =
                'Upper chart: a pulse of area x0 during the first step, s' +
                'o y(t) is the impulse response g(t). Lower chart: the ta' +
                'ngent at the point of largest slope gives R, L and T (Me' +
                'thod 1); MP is the largest output and %MP its overshoot.' +
                ' Mouse: wheel = zoom at the cursor (Shift: time only), d' +
                'rag to the lower right = zoom box, right drag = pan, dou' +
                'ble click = full view.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 6576709
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
              WordWrap = True
            end
          end
        end
        object gpPlant: TGridPanel
          Left = 300
          Top = 0
          Width = 800
          Height = 740
          Align = alClient
          BevelOuter = bvNone
          ColumnCollection = <
            item
              Value = 100.000000000000000000
            end>
          ControlCollection = <
            item
              Column = 0
              Control = chtImpulse
              Row = 0
            end
            item
              Column = 0
              Control = chtStep
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
          object chtImpulse: TChart
            Left = 0
            Top = 0
            Width = 800
            Height = 370
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
              'Runge Kutta Output: impulse response g(t)')
            BottomAxis.Grid.Color = 15132390
            BottomAxis.LabelsFormat.Font.Color = 5592405
            BottomAxis.LabelsFormat.Font.Height = -11
            BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
            BottomAxis.Title.Caption = 't (s)'
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
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 0
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            OnDblClick = ChartDblClick
            object serImpY: TFastLineSeries
              SeriesColor = 11694592
              Title = 'Impulse response g(t)'
              LinePen.Width = 3
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serImpPeak: TPointSeries
              SeriesColor = 7577088
              Title = 'Peak value'
              ClickableLine = False
              Pointer.HorizSize = 5
              Pointer.InflateMargins = True
              Pointer.Pen.Visible = False
              Pointer.Style = psTriangle
              Pointer.VertSize = 5
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
          object chtStep: TChart
            Left = 0
            Top = 370
            Width = 800
            Height = 370
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
              'Step response y(t) with the tangent of Method 1')
            BottomAxis.Grid.Color = 15132390
            BottomAxis.LabelsFormat.Font.Color = 5592405
            BottomAxis.LabelsFormat.Font.Height = -11
            BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
            BottomAxis.Title.Caption = 't (s)'
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
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 0
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            OnDblClick = ChartDblClick
            object serStepY: TFastLineSeries
              SeriesColor = 11694592
              Title = 'Step response y(t)'
              LinePen.Width = 3
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serStepTangent: TLineSeries
              SeriesColor = 24277
              Title = 'Tangent with slope R'
              Brush.BackColor = clDefault
              LinePen.Width = 2
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              Pointer.Visible = False
              XValues.Name = 'X'
              XValues.Order = loNone
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serStepInfl: TPointSeries
              SeriesColor = 10975692
              Title = 'Point of largest slope'
              ClickableLine = False
              Pointer.HorizSize = 5
              Pointer.InflateMargins = True
              Pointer.Pen.Visible = False
              Pointer.Style = psCircle
              Pointer.VertSize = 5
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serStepLT: TPointSeries
              SeriesColor = 40934
              Title = 'L and L + T'
              ClickableLine = False
              Pointer.HorizSize = 5
              Pointer.InflateMargins = True
              Pointer.Pen.Visible = False
              Pointer.Style = psDiamond
              Pointer.VertSize = 5
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serStepPeak: TPointSeries
              SeriesColor = 7577088
              Title = 'MP (peak value)'
              ClickableLine = False
              Pointer.HorizSize = 5
              Pointer.InflateMargins = True
              Pointer.Pen.Visible = False
              Pointer.Style = psTriangle
              Pointer.VertSize = 5
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
        end
      end
    end
    object tsZN1: TTabSheet
      Caption = 'Ziegler-Nichols Method 1 (Problem 3)'
      object pnlZN1Bg: TPanel
        Left = 0
        Top = 0
        Width = 1100
        Height = 740
        Align = alClient
        BevelOuter = bvNone
        Color = 16117996
        ParentBackground = False
        TabOrder = 0
        object pnlZN1Side: TPanel
          Left = 0
          Top = 0
          Width = 300
          Height = 740
          Align = alLeft
          BevelOuter = bvNone
          Color = 16117996
          Padding.Left = 6
          Padding.Top = 6
          Padding.Right = 6
          Padding.Bottom = 6
          ParentBackground = False
          TabOrder = 0
          object cardZN1Plant: TPanel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 288
            Height = 80
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Ziegler-Nichols Method 1'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            Tag = 10
            object btnZN1Plant1: TPanel
              Left = 12
              Top = 36
              Width = 128
              Height = 34
              BevelOuter = bvNone
              Caption = 'Plant 1'
              Color = 12608789
              Cursor = crHandPoint
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Plant 1: identify, compute the gains and run the closed loop'
              TabOrder = 0
              Tag = 1
              OnClick = btnZN1Plant1Click
            end
            object btnZN1Plant2: TPanel
              Left = 148
              Top = 36
              Width = 128
              Height = 34
              BevelOuter = bvNone
              Caption = 'Plant 2'
              Color = 12608789
              Cursor = crHandPoint
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Plant 2: identify, compute the gains and run the closed loop'
              TabOrder = 0
              Tag = 1
              OnClick = btnZN1Plant2Click
            end
          end
          object cardZN1Ctrl: TPanel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 288
            Height = 100
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Controller'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            Tag = 10
            object rgZN1Ctrl: TRadioGroup
              Left = 8
              Top = 30
              Width = 272
              Height = 64
              Color = 16578805
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ItemIndex = 2
              Items.Strings = (
                'Proportional Control (P)'
                'PI Control'
                'PID Control')
              ParentBackground = False
              ParentColor = False
              ParentFont = False
              TabOrder = 0
              OnClick = rgZN1CtrlClick
            end
          end
          object cardZN1Param: TPanel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 288
            Height = 128
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Parameter R, L (editable)'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            Tag = 12
            object lblZN1R: TLabel
              Left = 12
              Top = 38
              Width = 170
              Height = 15
              Caption = 'R (max slope, 1/s)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN1R: TEdit
              Left = 176
              Top = 34
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 15269119
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Largest slope of the step response per unit step'
              TabOrder = 0
            end
            object lblZN1L: TLabel
              Left = 12
              Top = 66
              Width = 170
              Height = 15
              Caption = 'L (apparent dead time, s)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN1L: TEdit
              Left = 176
              Top = 62
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 15269119
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Where the tangent crosses y = 0'
              TabOrder = 0
            end
            object btnZN1Gains: TPanel
              Left = 12
              Top = 92
              Width = 264
              Height = 28
              BevelOuter = bvNone
              Caption = 'Gains from R and L (Table 1.1)'
              Color = 12608789
              Cursor = crHandPoint
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Compute Kp, Ki, Kd from R and L and run'
              TabOrder = 0
              Tag = 2
              OnClick = btnZN1GainsClick
            end
          end
          object cardZN1PID: TPanel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 288
            Height = 156
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'PID Parameter (editable)'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            Tag = 12
            object lblZN1Kp: TLabel
              Left = 12
              Top = 38
              Width = 170
              Height = 15
              Caption = 'Kp (proportional gain)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN1Kp: TEdit
              Left = 176
              Top = 34
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 15269119
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Proportional gain'
              TabOrder = 0
            end
            object lblZN1Ki: TLabel
              Left = 12
              Top = 66
              Width = 170
              Height = 15
              Caption = 'Ki (integral gain, 1/s)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN1Ki: TEdit
              Left = 176
              Top = 62
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 15269119
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Integral gain'
              TabOrder = 0
            end
            object lblZN1Kd: TLabel
              Left = 12
              Top = 94
              Width = 170
              Height = 15
              Caption = 'Kd (derivative gain, s)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN1Kd: TEdit
              Left = 176
              Top = 90
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 15269119
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Derivative gain'
              TabOrder = 0
            end
            object btnZN1Run: TPanel
              Left = 12
              Top = 120
              Width = 264
              Height = 28
              BevelOuter = bvNone
              Caption = 'Run closed loop with Kp, Ki, Kd'
              Color = 12608789
              Cursor = crHandPoint
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Simulate the closed loop with the gains typed above'
              TabOrder = 0
              Tag = 1
              OnClick = btnZN1RunClick
            end
          end
          object cardZN1Perf: TPanel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 288
            Height = 270
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alClient
            BevelOuter = bvNone
            Caption = 'Performance (closed loop)'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            Tag = 16
            object lblZN1Rise: TLabel
              Left = 12
              Top = 36
              Width = 170
              Height = 15
              Caption = 'Rise Time (10 to 90 %, s)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN1Rise: TEdit
              Left = 176
              Top = 32
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Computed from the closed-loop response'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
            object lblZN1OS: TLabel
              Left = 12
              Top = 62
              Width = 170
              Height = 15
              Caption = 'Overshoot Percentage (%)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN1OS: TEdit
              Left = 176
              Top = 58
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Computed from the closed-loop response'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
            object lblZN1Max: TLabel
              Left = 12
              Top = 88
              Width = 170
              Height = 15
              Caption = 'Max Value'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN1Max: TEdit
              Left = 176
              Top = 84
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Computed from the closed-loop response'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
            object lblZN1Ts: TLabel
              Left = 12
              Top = 114
              Width = 170
              Height = 15
              Caption = 'Settling Time (2 %, s)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN1Ts: TEdit
              Left = 176
              Top = 110
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Computed from the closed-loop response'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
            object lblZN1Ess: TLabel
              Left = 12
              Top = 140
              Width = 170
              Height = 15
              Caption = 'Steady-state error'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN1Ess: TEdit
              Left = 176
              Top = 136
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Computed from the closed-loop response'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
            object lblZN1IAE: TLabel
              Left = 12
              Top = 166
              Width = 170
              Height = 15
              Caption = 'IAE'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN1IAE: TEdit
              Left = 176
              Top = 162
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Computed from the closed-loop response'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
            object lblZN1ISE: TLabel
              Left = 12
              Top = 192
              Width = 170
              Height = 15
              Caption = 'ISE'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN1ISE: TEdit
              Left = 176
              Top = 188
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Computed from the closed-loop response'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
            object lblZN1Stab: TLabel
              Left = 12
              Top = 218
              Width = 268
              Height = 19
              Caption = 'Closed loop: not simulated yet'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -14
              Font.Name = 'Segoe UI Semibold'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
          end
        end
        object gpZN1: TGridPanel
          Left = 300
          Top = 0
          Width = 800
          Height = 740
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
              ColumnSpan = 2
              Control = chtZN1Curve
              Row = 0
            end
            item
              Column = 0
              Control = chtZN1Y
              Row = 1
            end
            item
              Column = 1
              Control = chtZN1U
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
          object chtZN1Curve: TChart
            Left = 0
            Top = 0
            Width = 800
            Height = 370
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
              'Step response and tangent (Method 1)')
            BottomAxis.Grid.Color = 15132390
            BottomAxis.LabelsFormat.Font.Color = 5592405
            BottomAxis.LabelsFormat.Font.Height = -11
            BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
            BottomAxis.Title.Caption = 't (s)'
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
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 0
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            OnDblClick = ChartDblClick
            object serZN1CurveY: TFastLineSeries
              SeriesColor = 11694592
              Title = 'Plant output y(t)'
              LinePen.Width = 2
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serZN1Tangent: TLineSeries
              SeriesColor = 24277
              Title = 'Tangent with slope R'
              Brush.BackColor = clDefault
              LinePen.Width = 2
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              Pointer.Visible = False
              XValues.Name = 'X'
              XValues.Order = loNone
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serZN1LT: TPointSeries
              SeriesColor = 40934
              Title = 'L and L + T'
              ClickableLine = False
              Pointer.HorizSize = 5
              Pointer.InflateMargins = True
              Pointer.Pen.Visible = False
              Pointer.Style = psDiamond
              Pointer.VertSize = 5
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
          object chtZN1Y: TChart
            Left = 0
            Top = 370
            Width = 400
            Height = 370
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
              'PID Output ZN1: closed-loop output y(t)')
            BottomAxis.Grid.Color = 15132390
            BottomAxis.LabelsFormat.Font.Color = 5592405
            BottomAxis.LabelsFormat.Font.Height = -11
            BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
            BottomAxis.Title.Caption = 't (s)'
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
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 0
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            OnDblClick = ChartDblClick
            object serZN1Ref: TFastLineSeries
              SeriesColor = 0
              Title = 'Setpoint r'
              LinePen.Width = 1
              LinePen.Style = psDash
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serZN1Y: TFastLineSeries
              SeriesColor = 7577088
              Title = 'Plant output y(t)'
              LinePen.Width = 2
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
          object chtZN1U: TChart
            Left = 400
            Top = 370
            Width = 400
            Height = 370
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
              'Control signal u(t) (ZN1)')
            BottomAxis.Grid.Color = 15132390
            BottomAxis.LabelsFormat.Font.Color = 5592405
            BottomAxis.LabelsFormat.Font.Height = -11
            BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
            BottomAxis.Title.Caption = 't (s)'
            BottomAxis.Title.Font.Color = 3355443
            BottomAxis.Title.Font.Height = -12
            BottomAxis.Title.Font.Name = 'Segoe UI'
            LeftAxis.Grid.Color = 15132390
            LeftAxis.LabelsFormat.Font.Color = 5592405
            LeftAxis.LabelsFormat.Font.Height = -11
            LeftAxis.LabelsFormat.Font.Name = 'Segoe UI'
            LeftAxis.Title.Caption = 'u (-)'
            LeftAxis.Title.Font.Color = 3355443
            LeftAxis.Title.Font.Height = -12
            LeftAxis.Title.Font.Name = 'Segoe UI'
            View3D = False
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 0
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            OnDblClick = ChartDblClick
            object serZN1U: TFastLineSeries
              SeriesColor = 40934
              Title = 'Controller output u(t)'
              LinePen.Width = 2
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
        end
      end
    end
    object tsZN2: TTabSheet
      Caption = 'Ziegler-Nichols Method 2 (Problem 3)'
      object pnlZN2Bg: TPanel
        Left = 0
        Top = 0
        Width = 1100
        Height = 740
        Align = alClient
        BevelOuter = bvNone
        Color = 16117996
        ParentBackground = False
        TabOrder = 0
        object pnlZN2Side: TPanel
          Left = 0
          Top = 0
          Width = 300
          Height = 740
          Align = alLeft
          BevelOuter = bvNone
          Color = 16117996
          Padding.Left = 6
          Padding.Top = 6
          Padding.Right = 6
          Padding.Bottom = 6
          ParentBackground = False
          TabOrder = 0
          object cardZN2Plant: TPanel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 288
            Height = 80
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Ziegler-Nichols Method 2'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            Tag = 10
            object btnZN2Plant1: TPanel
              Left = 12
              Top = 36
              Width = 128
              Height = 34
              BevelOuter = bvNone
              Caption = 'Plant 1'
              Color = 12608789
              Cursor = crHandPoint
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Plant 1: identify, compute the gains and run the closed loop'
              TabOrder = 0
              Tag = 1
              OnClick = btnZN2Plant1Click
            end
            object btnZN2Plant2: TPanel
              Left = 148
              Top = 36
              Width = 128
              Height = 34
              BevelOuter = bvNone
              Caption = 'Plant 2'
              Color = 12608789
              Cursor = crHandPoint
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Plant 2: identify, compute the gains and run the closed loop'
              TabOrder = 0
              Tag = 1
              OnClick = btnZN2Plant2Click
            end
          end
          object cardZN2Ctrl: TPanel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 288
            Height = 100
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Controller'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            Tag = 10
            object rgZN2Ctrl: TRadioGroup
              Left = 8
              Top = 30
              Width = 272
              Height = 64
              Color = 16578805
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ItemIndex = 2
              Items.Strings = (
                'Proportional Control (P)'
                'PI Control'
                'PID Control')
              ParentBackground = False
              ParentColor = False
              ParentFont = False
              TabOrder = 0
              OnClick = rgZN2CtrlClick
            end
          end
          object cardZN2Param: TPanel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 288
            Height = 128
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'Parameter Ku, Pu (editable)'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            Tag = 12
            object lblZN2Ku: TLabel
              Left = 12
              Top = 38
              Width = 170
              Height = 15
              Caption = 'Ku (critical gain)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN2Ku: TEdit
              Left = 176
              Top = 34
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 15269119
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Critical gain: P loop at the edge of stability'
              TabOrder = 0
            end
            object lblZN2Pu: TLabel
              Left = 12
              Top = 66
              Width = 170
              Height = 15
              Caption = 'Pu (period of oscillation, s)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN2Pu: TEdit
              Left = 176
              Top = 62
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 15269119
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Period of the oscillation at Ku'
              TabOrder = 0
            end
            object btnZN2TestKu: TPanel
              Left = 12
              Top = 92
              Width = 130
              Height = 28
              BevelOuter = bvNone
              Caption = 'Test Ku (measure Pu)'
              Color = 12608789
              Cursor = crHandPoint
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Simulate the P loop at the typed Ku and measure Pu'
              TabOrder = 0
              Tag = 2
              OnClick = btnZN2TestKuClick
            end
            object btnZN2Gains: TPanel
              Left = 148
              Top = 92
              Width = 128
              Height = 28
              BevelOuter = bvNone
              Caption = 'Gains from Ku, Pu'
              Color = 12608789
              Cursor = crHandPoint
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Compute Kp, Ki, Kd from Ku and Pu (Table 1.2) and run'
              TabOrder = 0
              Tag = 2
              OnClick = btnZN2GainsClick
            end
          end
          object cardZN2PID: TPanel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 288
            Height = 156
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alTop
            BevelOuter = bvNone
            Caption = 'PID Parameter (editable)'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            Tag = 12
            object lblZN2Kp: TLabel
              Left = 12
              Top = 38
              Width = 170
              Height = 15
              Caption = 'Kp (proportional gain)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN2Kp: TEdit
              Left = 176
              Top = 34
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 15269119
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Proportional gain'
              TabOrder = 0
            end
            object lblZN2Ki: TLabel
              Left = 12
              Top = 66
              Width = 170
              Height = 15
              Caption = 'Ki (integral gain, 1/s)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN2Ki: TEdit
              Left = 176
              Top = 62
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 15269119
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Integral gain'
              TabOrder = 0
            end
            object lblZN2Kd: TLabel
              Left = 12
              Top = 94
              Width = 170
              Height = 15
              Caption = 'Kd (derivative gain, s)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN2Kd: TEdit
              Left = 176
              Top = 90
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 15269119
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Derivative gain'
              TabOrder = 0
            end
            object btnZN2Run: TPanel
              Left = 12
              Top = 120
              Width = 264
              Height = 28
              BevelOuter = bvNone
              Caption = 'Run closed loop with Kp, Ki, Kd'
              Color = 12608789
              Cursor = crHandPoint
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Simulate the closed loop with the gains typed above'
              TabOrder = 0
              Tag = 1
              OnClick = btnZN2RunClick
            end
          end
          object cardZN2Perf: TPanel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 288
            Height = 270
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 6
            Align = alClient
            BevelOuter = bvNone
            Caption = 'Performance (closed loop)'
            Color = 16578805
            ParentBackground = False
            ShowCaption = False
            TabOrder = 0
            Tag = 16
            object lblZN2Rise: TLabel
              Left = 12
              Top = 36
              Width = 170
              Height = 15
              Caption = 'Rise Time (10 to 90 %, s)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN2Rise: TEdit
              Left = 176
              Top = 32
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Computed from the closed-loop response'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
            object lblZN2OS: TLabel
              Left = 12
              Top = 62
              Width = 170
              Height = 15
              Caption = 'Overshoot Percentage (%)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN2OS: TEdit
              Left = 176
              Top = 58
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Computed from the closed-loop response'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
            object lblZN2Max: TLabel
              Left = 12
              Top = 88
              Width = 170
              Height = 15
              Caption = 'Max Value'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN2Max: TEdit
              Left = 176
              Top = 84
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Computed from the closed-loop response'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
            object lblZN2Ts: TLabel
              Left = 12
              Top = 114
              Width = 170
              Height = 15
              Caption = 'Settling Time (2 %, s)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN2Ts: TEdit
              Left = 176
              Top = 110
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Computed from the closed-loop response'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
            object lblZN2Ess: TLabel
              Left = 12
              Top = 140
              Width = 170
              Height = 15
              Caption = 'Steady-state error'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN2Ess: TEdit
              Left = 176
              Top = 136
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Computed from the closed-loop response'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
            object lblZN2IAE: TLabel
              Left = 12
              Top = 166
              Width = 170
              Height = 15
              Caption = 'IAE'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN2IAE: TEdit
              Left = 176
              Top = 162
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Computed from the closed-loop response'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
            object lblZN2ISE: TLabel
              Left = 12
              Top = 192
              Width = 170
              Height = 15
              Caption = 'ISE'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object edtZN2ISE: TEdit
              Left = 176
              Top = 188
              Width = 100
              Height = 23
              Alignment = taRightJustify
              Color = 16118254
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              Hint = 'Computed from the closed-loop response'
              ReadOnly = True
              TabStop = False
              TabOrder = 0
            end
            object lblZN2Stab: TLabel
              Left = 12
              Top = 218
              Width = 268
              Height = 19
              Caption = 'Closed loop: not simulated yet'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 3682854
              Font.Height = -14
              Font.Name = 'Segoe UI Semibold'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
          end
        end
        object gpZN2: TGridPanel
          Left = 300
          Top = 0
          Width = 800
          Height = 740
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
              ColumnSpan = 2
              Control = chtZN2Ku
              Row = 0
            end
            item
              Column = 0
              Control = chtZN2Y
              Row = 1
            end
            item
              Column = 1
              Control = chtZN2U
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
          object chtZN2Ku: TChart
            Left = 0
            Top = 0
            Width = 800
            Height = 370
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
              'P control at Kp = Ku (oscillation and period Pu)')
            BottomAxis.Grid.Color = 15132390
            BottomAxis.LabelsFormat.Font.Color = 5592405
            BottomAxis.LabelsFormat.Font.Height = -11
            BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
            BottomAxis.Title.Caption = 't (s)'
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
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 0
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            OnDblClick = ChartDblClick
            object serZN2KuY: TFastLineSeries
              SeriesColor = 15316054
              Title = 'Plant output y(t)'
              LinePen.Width = 2
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serZN2KuRef: TFastLineSeries
              SeriesColor = 0
              Title = 'Setpoint r'
              LinePen.Width = 1
              LinePen.Style = psDash
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serZN2KuPeaks: TPointSeries
              SeriesColor = 24277
              Title = 'Peaks (spacing = Pu)'
              ClickableLine = False
              Pointer.HorizSize = 4
              Pointer.InflateMargins = True
              Pointer.Pen.Visible = False
              Pointer.Style = psCircle
              Pointer.VertSize = 4
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
          object chtZN2Y: TChart
            Left = 0
            Top = 370
            Width = 400
            Height = 370
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
              'PID Output ZN2: closed-loop output y(t)')
            BottomAxis.Grid.Color = 15132390
            BottomAxis.LabelsFormat.Font.Color = 5592405
            BottomAxis.LabelsFormat.Font.Height = -11
            BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
            BottomAxis.Title.Caption = 't (s)'
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
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 0
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            OnDblClick = ChartDblClick
            object serZN2Ref: TFastLineSeries
              SeriesColor = 0
              Title = 'Setpoint r'
              LinePen.Width = 1
              LinePen.Style = psDash
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object serZN2Y: TFastLineSeries
              SeriesColor = 7577088
              Title = 'Plant output y(t)'
              LinePen.Width = 2
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
          object chtZN2U: TChart
            Left = 400
            Top = 370
            Width = 400
            Height = 370
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
              'Control signal u(t) (ZN2)')
            BottomAxis.Grid.Color = 15132390
            BottomAxis.LabelsFormat.Font.Color = 5592405
            BottomAxis.LabelsFormat.Font.Height = -11
            BottomAxis.LabelsFormat.Font.Name = 'Segoe UI'
            BottomAxis.Title.Caption = 't (s)'
            BottomAxis.Title.Font.Color = 3355443
            BottomAxis.Title.Font.Height = -12
            BottomAxis.Title.Font.Name = 'Segoe UI'
            LeftAxis.Grid.Color = 15132390
            LeftAxis.LabelsFormat.Font.Color = 5592405
            LeftAxis.LabelsFormat.Font.Height = -11
            LeftAxis.LabelsFormat.Font.Name = 'Segoe UI'
            LeftAxis.Title.Caption = 'u (-)'
            LeftAxis.Title.Font.Color = 3355443
            LeftAxis.Title.Font.Height = -12
            LeftAxis.Title.Font.Name = 'Segoe UI'
            View3D = False
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 0
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            OnDblClick = ChartDblClick
            object serZN2U: TFastLineSeries
              SeriesColor = 40934
              Title = 'Controller output u(t)'
              LinePen.Width = 2
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
    Top = 840
    Width = 1400
    Height = 20
    Panels = <
      item
        Width = 1000
      end
      item
        Width = 50
      end>
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
end
