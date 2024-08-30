import os
import json
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException

from crewai import Crew, Agent, Task
from pydantic import BaseModel
from dto.crewai_dto import *

app = FastAPI()


def create_mas_system(crew_resources: CrewResources):
    # 실제 CrewAI와의 연동 로직이 여기에 포함될 수 있음 (아직 미완성)
    # 어떻게 입력 받고 생성할 지 구현해야함
    mas_system = {
        "agents": {},
        "tasks": []
    }

    # Agent Parsing (Input되는 객체에서 필요한 key 파싱)
    for agent_name, agent_list in crew_resources.agents.items():
        mas_system["agents"][agent_name] = []
        for agent in agent_list:
            mas_agent = {
                "name": agent.name,
                "llm": agent.llm,
                "role": agent.role,
                "goal": agent.goal,
                "backstory": agent.backstory,
                "tools": [{"name": tool.name, "description": tool.description} for tool in (agent.tools or [])]
            }
            mas_system["agents"][agent_name].append(mas_agent)

    # Task Parsing (Input되는 객체에서 필요한 key 파싱)
    for task_name, task in crew_resources.tasks.items():
        mas_task = {
            "name": task_name,
            "description": task.description,
            "target_agent": task.target_agent,
            "expected_output": task.expected_output
        }
        mas_system["tasks"].append(mas_task)

    return mas_system


@app.post("/resource")
def make_resource(data: InputData):
    crew_resources = data.crew_resources

    # MAS 생성 로직 - CrewAI로의 변환 로직이 여기에 들어갈거임!! 위에서 MAS System
    mas_system = create_mas_system(crew_resources)

    # MAS 시스템의 출력 (예시)
    return {
        "status": True,
        "crew_output": mas_system  # Crew 생성 후 kickoff의 결과값 보낼 것!
    }
