import os
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Dict, Optional
from crewai import Crew, Agent, Task
from dotenv import load_dotenv

from tools.search_tools import SearchTools  # 도구 클래스 임포트

# .env 파일에서 환경변수 로드
load_dotenv()

app = FastAPI()

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 실제 운영 환경에서는 구체적인 origin을 지정해야 합니다
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# OpenAI API 키 설정
openai_api_key = os.getenv("OPENAI_API_KEY")
if not openai_api_key:
    raise ValueError("OPENAI_API_KEY가 설정되지 않았습니다.")

class Tool(BaseModel):
    name: str
    description: str

# tools 사용을 위해 AgentModel 수정 240830
class AgentModel(BaseModel):
    name: str
    role: str
    goal: str
    backstory: str
    tools: List[str]  # 도구 이름 목록으로 변경

class TaskModel(BaseModel):
    name: str
    description: str
    target_agent: str
    expected_output: str

class CrewResources(BaseModel):
    agents: Dict[str, List[AgentModel]]
    tasks: Dict[str, TaskModel]

class InputData(BaseModel):
    crew_resources: CrewResources

# 사용 가능한 도구 목록을 반환하는 엔드포인트 추가
@app.get("/available_tools")
async def get_available_tools():
    tools = [
        {"name": "Search internet", "description": "Useful to search the internet about a given topic and return relevant results."},
        {"name": "Search instagram", "description": "Useful to search for instagram post about a given topic and return relevant results."},
        # 추가 도구들...
    ]
    return {"tools": tools}

@app.post("/execute_crew")
async def execute_crew(data: InputData):
    print(f"Received data: {data.dict()}")  # 데이터 형식 맞추기 위해 추가된 로그
    try:
        # CrewAI 객체 생성
        agents = []
        for agent_data in data.crew_resources.agents['agent_list']:
            agent_tools = [getattr(SearchTools, tool_name) for tool_name in agent_data.tools if hasattr(SearchTools, tool_name)]
            agent = Agent(
                name=agent_data.name,
                role=agent_data.role,
                goal=agent_data.goal,
                backstory=agent_data.backstory,
                tools=agent_tools
            )
            agents.append(agent)

        tasks = []
        for task_name, task_data in data.crew_resources.tasks.items():
            task = Task(
                description=task_data.description,
                agent=next(agent for agent in agents if agent.name == task_data.target_agent)
            )
            tasks.append(task)

        crew = Crew(
            agents=agents,
            tasks=tasks
        )

        # Crew 실행
        result = crew.kickoff()

        return {
            "status": "success",
            "result": result
        }
    except Exception as e:
        print(f"Error: {str(e)}")  # 데이터 형식 맞추기 위해 추가된 로그
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)