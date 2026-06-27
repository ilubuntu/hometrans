# calculatorHarmony 自测用例

## Spec: 主计算页面

### Scenario: 完成一次加法计算
- 动作：打开com.example.calculatorharmony -> 点击1 -> 点击+ -> 点击2 -> 点击=
- 预期结果：主计算页面仍然展示，表达式展示1 + 2，结果展示3.0

### Scenario: 清除当前输入
- 动作：打开com.example.calculatorharmony -> 点击9 -> 点击C
- 预期结果：主计算页面仍然展示，当前输入恢复为0

### Scenario: 完成一次乘法计算
- 动作：打开com.example.calculatorharmony -> 点击4 -> 点击× -> 点击5 -> 点击=
- 预期结果：主计算页面仍然展示，表达式展示4 × 5，结果展示20.0

## Spec: 深色模式

### Scenario: 切换深色模式并保持输入
- 动作：打开com.example.calculatorharmony -> 点击7 -> 点击主题切换按钮
- 预期结果：页面切换为深色视觉样式，当前输入7仍然保留

### Scenario: 深色模式下继续计算
- 动作：打开com.example.calculatorharmony -> 点击主题切换按钮 -> 点击3 -> 点击+ -> 点击4 -> 点击=
- 预期结果：页面保持深色视觉样式，表达式展示3 + 4，结果展示7.0

## Spec: 历史记录

### Scenario: 查看历史记录并恢复计算
- 动作：打开com.example.calculatorharmony -> 点击4 -> 点击+ -> 点击5 -> 点击= -> 点击历史记录按钮 -> 点击历史记录中的4 + 5
- 预期结果：历史记录页面展示4 + 5和结果9.0，点击记录后回到主计算页面并恢复表达式4 + 5和结果9.0

### Scenario: 清空历史记录后展示空状态
- 动作：打开com.example.calculatorharmony -> 点击1 -> 点击+ -> 点击1 -> 点击= -> 点击历史记录按钮 -> 点击清空历史按钮 -> 点击Clear
- 预期结果：历史记录被清空，页面展示Nothing to show!空状态
