/*
  在这个文件中，我计划设计一个flake-part module的模板，作为我的配置系统的新的基本功能模块。作为配置的基础，请你参考flake-part框架、the dendritic pattern

  关于这个框架和模块设计的细节：
  
  1. nix文件定位
  
    每一个nix文件对应一个功能，起到两方面作用：一方面直接导出一个flake-part模块到系统中，形成系统中的一个功能；另一方面导出到flake输出，用于功能共享。

    1.1. nix文件作为一个系统功能组件
    
      每个文件定义一个flake-part module，借由其它代码自动导入到配置系统中。这个flake-part模块定义nixos module和home-manager module (以及后续可能的其它module类型)，是该功能的系统和用户层实现。
      
      作为系统组件，可以预期其中的nixos和home-manager module将通过某种路径被import到nixosConfiguration或homeConfiguration下。此时的host与user信息需要经过flake-part module或者文件的输入（此时文件是一个输出为flake-part module的函数），对option进行修改，以便我在同一个配置系统中定义多机器多用户。这里虽然一般的nix框架想要将功能组成和具体配置分开写，但我更想要它们集中到同一个功能的文件内。

    1.2. nix文件作为一个共享功能实现
    
      它上面定义的模块分别通过flake.modules.parts, flake.modules.nixos, flake.modules.homeManager导出，供给外部使用。

      与上面相对应，作为一个导出模块时上述这些module不应该预期接受任何格式的输入，而是通过内部的option定义来提供外部控制接口。

  2. 层次功能定义

    为了合理组织功能模块，我当然希望一个nix文件定义的功能，可以实现为另外几个nix文件中功能的某种组合形式。

    对于当前系统的功能组件，这些nix文件应该是DAG结构，源点为一个user@host配置，每个节点是一组或一个功能；作为导出功能，导出功能A时，能够附带上其子功能模块就好，不用在意其父功能是什么。

    这个依赖关系的定义可能的实现包括：
      
      a. 通过flake-part module的import实现
      
      b. nixos， home-manager module分别import其对应的子模块

      c. 通过option实现（这个能否实现不确定，似乎导出时会有问题）

    我尚不明确哪个最好，需要分析。
  
  3. 模块命名

    当然命名是必不可少的，上面同一功能的三种命名可以用同一个。按照类似"feature/system/network/vpn"方式命名。

 */