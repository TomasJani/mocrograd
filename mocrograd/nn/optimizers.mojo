from . import modules


trait Optimizer:
    fn step(self) raises -> None:
        ...

    fn zero_grad(self) raises -> None:
        ...
    
    fn __moveinit__(inout self, owned existing: Self):
        ...


struct SGD(Optimizer):
    var parameters_dict: modules.ParametersDict
    var learning_rate: Float32

    fn __init__(
        inout self, parameters_dict: modules.ParametersDict, learning_rate: Float32
    ) -> None:
        self.parameters_dict = parameters_dict
        self.learning_rate = learning_rate

    fn step(self) raises -> None:
        for parameters_sequence in self.parameters_dict.values():
            for parameters in parameters_sequence[]:
                if not parameters[].grad:
                    raise "MissingGradError"
                for row in range(parameters[].rows):
                    for col in range(parameters[].cols):
                        parameters[][row, col] -= (
                            self.learning_rate * parameters[].grad.value()[row, col]
                        )

    fn zero_grad(self) raises -> None:
        for parameters_sequence in self.parameters_dict.values():
            for parameters in parameters_sequence[]:
                var params_grad = parameters[].grad
                if not params_grad:
                    raise "MissingGradError"
                for row in range(parameters[].rows):
                    for col in range(parameters[].cols):
                        params_grad.value()[row, col] = Float32(0.0)

    fn __moveinit__(inout self, owned existing: Self):
        self.parameters_dict = existing.parameters_dict
        self.learning_rate = existing.learning_rate
