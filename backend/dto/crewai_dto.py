from pydantic import BaseModel
from typing import List, Optional, Dict


class Tool(BaseModel):
    name: str
    description: str

# 각 에이전트를 나타내는 모델


class Agent(BaseModel):
    name: str
    llm: str
    role: str
    goal: str
    backstory: str
    tools: Optional[List[Tool]] = None

# 각 작업을 나타내는 모델


class Task(BaseModel):
    description: str
    target_agent: str
    expected_output: str

# 전체 크루 리소스를 나타내는 모델


class CrewResources(BaseModel):
    agents: Dict[str, List[Agent]]
    tasks: Dict[str, Task]

# 입력 데이터 모델


class InputData(BaseModel):
    crew_resources: CrewResources
