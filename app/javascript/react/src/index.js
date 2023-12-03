import { define } from 'remount'      
import Hello from "./components/Hello"
import Graph from "./components/Graph"
import CreateExperiment from "./components/CreateExperiment"
                                      
define({ 'hello-component': Hello, 'graph-component': Graph, 'create-experiment-component': CreateExperiment })