[Mesh]
  file = './mesh/billiald2.msh'
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
    fridge =0.100
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
    value =0.100
  [../]

  [./Vplus]
    type = DirichletBC
    variable = V
    boundary = 1
    #value =2.309e-06
    value = 0.1
  [../]

  [./Vminus]
    type = DirichletBC
    variable = V
    boundary = 2
    value = 0
  [../]
[]

[Materials]

  [./GaAs]
    type = SheetParam
    length_scale = 1e-4 # in 100um
    Alpha =1
    Beta =10000
  [../]

[]


#[Adaptivity]
#  marker = errorfrac
#  steps = 6
#  [./Indicators]
#    [./error]
#      type = GradientJumpIndicator
#      variable = T
#      outputs = none
#    [../]
#  [../]
#  [./Markers]
#    [./errorfrac]
#      type = ErrorFractionMarker
#      refine = 0.5
#      coarsen = 0
#      indicator = error
#      outputs = none
#    [../]
#  [../]
#[]

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
