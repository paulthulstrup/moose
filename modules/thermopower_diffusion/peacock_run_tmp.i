# [DiracKernels]
# [./example_point_source1]
# type = ExampleDirac
# variable = T
# value =1
# point = '0 0 0'
# [../]
# 
# [./example_point_source2]
# type = ExampleDirac
# variable = T
# value =1
# point = '0.1 0 0'
# [../]
# 
# [./example_point_source3]
# type = ExampleDirac
# variable = T
# value =1
# point = '0.2 0 0'
# [../]
# 
# [./example_point_source4]
# type = ExampleDirac
# variable = T
# value =1
# point = '0.3 0 0'
# [../]
# 
# [./example_point_source5]
# type = ExampleDirac
# variable = T
# value =1
# point = '0.4 0 0'
# [../]
# 
# [./example_point_source6]
# type = ExampleDirac
# variable = T
# value =1
# point = '0.5 0 0'
# [../]
# 
# []

[Mesh]
  type = FileMesh
  file = ./mesh/normal_L.msh
[]

[Variables]
  # Variable for the temperature field
  # Variable for the potential field
  [./T]
    order = FIRST
    family = LAGRANGE
  [../]
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
    fridge = 0.002
  [../]
  [./ThermalDiffusion]
    type = Diffusion
    variable = T
  [../]
[]

[BCs]
  [./TCold]
    type = DirichletBC
    variable = T
    boundary = 3
    value = 0.002
  [../]
  [./THot]
    type = DirichletBC
    variable = T
    boundary = 2
    value = 0.0025
  [../]
[]

[Materials]
  [./GaAs]
    type = SheetParam
    length_scale = 1e-4 # in 100um
    Alpha = 0.38
    Beta = 0
  [../]
[]

[Adaptivity]
  marker = errorfrac
  steps = 6
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
  execute_on = timestep_end
  exodus = true
[]

