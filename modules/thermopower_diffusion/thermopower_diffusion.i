[Mesh]
  file = './mesh/diag_bar_1.msh'
[]

[Variables]
  # Variable for the temperature field
  [./T]
    order = FIRST
    family = LAGRANGE
  [../]

  # Variable for the potential field
  [./V]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./Laplace]
    type = LaplaceEq
    variable = V
    resistance = 1
  [../]

  [./ThermoElectricDiffusion]
    type = ThermoPowerDiffusion
    variable = T
    some_variable = V
    Alpha_n = sinking
    Beta_n = heating
    fridge =0.0289
  [../]

  [./ThermalDiffusion]
    type = Diffusion
    variable = T
  [../]
[]

[DiracKernels]
  [./example_point_source]
    type = ExampleDirac
    variable = T
    value =10
    point = '0.25 0 0'
  [../]
[]


[BCs]
  [./TCold]
    type = DirichletBC
    variable = T
    boundary = 3
    value =0.0289
  [../]


 #[./THot]
 #  type = DirichletBC
 #  variable = T
 #  boundary = 2
 #  value =0.3089
 # [../]

[]


[Materials]

  [./GaAs]
    type = SheetParam
    length_scale = 1e-4 # in 100um
    Alpha =3.5
    Beta =0
  [../]

[]


[Adaptivity]
  marker = errorfrac
  steps = 4
  [./Indicators]
    [./error]
      type = GradientJumpIndicator
      variable = T
      outputs = none
    [../]
  [../]
  [./Markers]
    [./errorfrac]
      type = ErrorFractionMarker
      refine = 0.5
      coarsen = 0
      indicator = error
      outputs = none
    [../]
  [../]
[]

[Executioner]
  type = Steady
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
