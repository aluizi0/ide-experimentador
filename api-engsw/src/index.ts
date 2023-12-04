import { Elysia, NotFoundError } from "elysia";

const persons = ["nurse"]
const robots = ["lab_arm"]
type coordinates = {x: number, y:number, z:number}
type localPlan = {
  skill: string,
  params: any[]
  label: string,
}
type testType = {
  log: string,
  nurses: Array<{location: string, position: coordinates}>,
  startTime: number,
  duration: number,
  robots: Array<{
    id: number,
    avg_speed: number,
    battery_charge: number,
    battery_discharge_rate: number,
    name: string,
    location: string,
    skills: string[]
    local_plan: Array<localPlan>
    position: coordinates
  }>
}
const tests: Record<number, testType> = {}

const availiableSkills = [
  {
    skillName: "approach_person",
    paramType: "topicPerson",
    availiableParams: persons
  },
  {
    skillName: "approach_robot",
    paramType: "topicRobot",
    availiableParams: robots
  },
  {
    skillName: "authenticate_person",
    paramType: "topicPerson",
    availiableParams: persons
  },
  {
    skillName: "navigation",
    paramType: "coordinatesArray",
  },
  {
    skillName: "operate_drawer",
    paramType: "action",
    availiableParams: ["close", "open"]
  },
  {
    skillName: "wait_message",
    paramType: "entity",
    availiableParams: { persons, robots }
  },
  {
    skillName: "send_message",
    paramType: "topic",
    availiableParams: { persons, robots }
  },
]

const mockLogs = [
  `10.05, [INFO], robot3, {'battery-level': '45.91'}, None, None
10.05, [INFO], robot3, {'y': 18.0, 'x': -13.5, 'yaw': -3.142}, None, None
20.08, [INFO], robot3, {'battery-level': '45.51'}, None, None
20.08, [INFO], robot3, {'y': 16.126, 'x': -13.642, 'yaw': -3.141}, None, None
30.01, [INFO], robot3, {'y': 15.992, 'x': -15.743, 'yaw': 3.142}, None, None
30.01, [INFO], robot3, {'battery-level': '45.11'}, None, None
40.07, [INFO], robot3, {'y': 15.96, 'x': -17.865, 'yaw': 3.14}, None, None
40.07, [INFO], robot3, {'battery-level': '44.71'}, None, None
50.09, [INFO], robot3, {'battery-level': '44.31'}, None, None
50.09, [INFO], robot3, {'y': 16.14, 'x': -19.971, 'yaw': -3.142}, None, None
60.03, [INFO], robot3, {'battery-level': '43.91'}, None, None
60.03, [INFO], robot3, {'y': 16.163, 'x': -22.073, 'yaw': 3.142}, None, None
70.05, [INFO], robot3, {'battery-level': '43.51'}, None, None
70.05, [INFO], robot3, {'y': 16.098, 'x': -24.201, 'yaw': 3.141}, None, None
80.07, [INFO], robot3, {'battery-level': '43.11'}, None, None
80.07, [INFO], robot3, {'y': 16.037, 'x': -26.315, 'yaw': 3.142}, None, None
90.00, [INFO], robot3, {'y': 16.182, 'x': -28.41, 'yaw': -3.142}, None, None
90.00, [INFO], robot3, {'battery-level': '42.71'}, None, None
100.05, [INFO], robot3, {'battery-level': '42.31'}, None, None
100.05, [INFO], robot3, {'y': 16.117, 'x': -30.529, 'yaw': 3.142}, None, None
110.08, [INFO], robot3, {'y': 15.855, 'x': -32.652, 'yaw': -3.141}, None, None
110.08, [INFO], robot3, {'battery-level': '41.91'}, None, None
120.02, [INFO], robot3, {'battery-level': '41.51'}, None, None
120.02, [INFO], robot3, {'y': 15.353, 'x': -34.716, 'yaw': -3.142}, None, None
130.02, [INFO], robot3, {'battery-level': '41.11'}, None, None
130.02, [INFO], robot3, {'y': 15.937, 'x': -36.699, 'yaw': 3.141}, None, None
140.07, [INFO], robot3, {'battery-level': '40.71'}, None, None
140.07, [INFO], robot3, {'y': 18.058, 'x': -36.625, 'yaw': 3.141}, None, None
150.09, [INFO], robot3, {'battery-level': '40.31'}, None, None
150.09, [INFO], robot3, {'y': 20.168, 'x': -36.83, 'yaw': -3.138}, None, None
160.03, [INFO], robot3, {'y': 21.529, 'x': -37.913, 'yaw': 3.142}, None, None
160.03, [INFO], robot3, {'battery-level': '39.91'}, None, None
170.06, [INFO], robot3, {'battery-level': '39.51'}, None, None
170.06, [INFO], robot3, {'y': 21.419, 'x': -38.066, 'yaw': 3.141}, None, None
172.37, [info], nurse, sync, received-request, (status=sending-request)
172.37, [info], nurse, sync, request-sent, (status=waiting)
172.37, [info], nurse, sync, wait-message, (status=message-received)
180.02, [INFO], robot3, {'battery-level': '39.11'}, None, None
180.02, [INFO], robot3, {'y': 20.755, 'x': -37.19, 'yaw': 3.141}, None, None
190.01, [INFO], robot3, {'battery-level': '38.71'}, None, None
190.01, [INFO], robot3, {'y': 18.648, 'x': -37.137, 'yaw': 3.142}, None, None
200.04, [INFO], robot3, {'battery-level': '38.31'}, None, None
200.04, [INFO], robot3, {'y': 16.534, 'x': -37.095, 'yaw': 3.141}, None, None
210.03, [INFO], robot3, {'battery-level': '37.91'}, None, None
210.03, [INFO], robot3, {'y': 15.627, 'x': -35.367, 'yaw': 3.142}, None, None
220.08, [INFO], robot3, {'y': 15.405, 'x': -33.262, 'yaw': -3.141}, None, None
220.08, [INFO], robot3, {'battery-level': '37.51'}, None, None
230.05, [INFO], robot3, {'battery-level': '37.11'}, None, None
230.05, [INFO], robot3, {'y': 15.53, 'x': -31.145, 'yaw': -3.141}, None, None
240.08, [INFO], robot3, {'battery-level': '36.71'}, None, None
240.08, [INFO], robot3, {'y': 15.736, 'x': -29.036, 'yaw': 3.141}, None, None
250.03, [INFO], robot3, {'battery-level': '36.31'}, None, None
250.03, [INFO], robot3, {'y': 15.787, 'x': -26.938, 'yaw': 3.141}, None, None
260.01, [INFO], robot3, {'battery-level': '35.91'}, None, None
260.01, [INFO], robot3, {'y': 14.328, 'x': -25.726, 'yaw': -3.141}, None, None
270.03, [INFO], robot3, {'y': 12.912, 'x': -25.955, 'yaw': 3.141}, None, None
270.03, [INFO], robot3, {'battery-level': '35.51'}, None, None
276.00, [info], lab_arm, sync, wait-message, (status=message-received)
276.93, [WARN], robot3, SUCCESS, None, None`
]

const app = new Elysia()
  .get("/", () => "mock api")
  .get("/skills", () => availiableSkills)
  .post("/run", ({body}: any) => {
    const duration = Math.random() * 10
    const lastIndex = Object.keys(tests).length
    tests[lastIndex+1] = {...body.test, startTime: new Date(), duration}
  }) 
  .onError(({code, set}) => {
    if (code==='NOT_FOUND'){
      set.status = 404
      return 'test not found'
    }
  })
  .get("/status/:id", ({params: {id}}) => {
    if(tests[parseInt(id)]){
      const now = Date.now()
      if((tests[parseInt(id)].startTime-now) < tests[parseInt(id)].duration){
        return {status: "running"}
      } else {
        const status: string = (Math.random()*100) < 90 ? "success" : "failed"
        delete tests[parseInt(id)]
        return {status, log: mockLogs[0]}
      } 
    } else {
      throw new NotFoundError()
    }
  })
  .delete("/stop/:id", ({params: {id}}) => {
    if(tests[parseInt(id)]){
      delete tests[parseInt(id)]
    } else {
      throw new NotFoundError()
    } 
  }) 
  .listen(3000);

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);
