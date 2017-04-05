[Mesh]
  file = 'normal_L.msh'
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
    fridge = 0.1
  [../]

  [./TermalDiffusion]
    type = Diffusion
    variable = T
  [../]
[]

[BCs]
  [./TCold]
    type = DirichletBC
    variable = T
    boundary = 3
    value =0.1
  [../]

  [./THot]
    type = DirichletBC
    variable = T
    boundary = 2
    value =0.1
  [../]

  [./Vplus]
    type = DirichletBC
    variable = V
    boundary = 4
    value = 0.15
  [../]

  [./Vminus]
    type = DirichletBC
    variable = V
    boundary = 5
    value = 0.05
  [../]
[]

[Materials]

  [./GaAs]
    type = SheetParam
    length_scale = 1e-4 # in 100um
    Alpha =0.1
    Beta =0.1
  [../]

[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
[]

[Postprocessors]
  [./node_val]
    type = NodalVariableValue
    variable = T
    nodeid = 180
  [../]
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
  csv = true
[]

