import synaptic, {Neuron, Layer, Network, Trainer, Architect} from 'synaptic';

class Perceptron extends Network
{
    constructor(uInput, uHidden, uOutput) {

        const lInput = new Layer(uInput),
            lHidden = new Layer(uHidden),
            lOutput = new Layer(uOutput);

        lInput.project(lHidden);
        lHidden.project(lOutput);

        this.set({
            input: lInput,
            hidden: [lHidden],
            output: lOutput
        });
    }
}

const myPerceptron = new Perceptron(2,3,1);
const myTrainer = new Trainer(myPerceptron);

myTrainer.XOR();

myPerceptron.activate([0,0]);
myPerceptron.activate([1,0]);
myPerceptron.activate([0,1]);
myPerceptron.activate([1,1]);
