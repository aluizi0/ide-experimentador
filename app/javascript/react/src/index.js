import { define } from 'remount'      
import Hello from "./components/Hello"
import Graph from "./components/Graph"
import CreateExperiment from "./components/CreateExperiment"
import ClassificationExperiment from './components/ClassificationExperiment'
                                      
define({ 'hello-component': Hello, 'graph-component': Graph, 'create-experiment-component': CreateExperiment, 'create-classification-experiment-component': ClassificationExperiment })