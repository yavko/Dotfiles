{inputs, impurity, ...}: {

	home-manager.extraSpecialArgs = {inherit impurity;};
	
	imports = [inputs.impurity.nixosModules.impurity];
	impurity.configRoot = inputs.self;
}
