from pydantic import BaseModel, Field, field_validator
from datetime import datetime
from typing import Optional, Literal


# Task Schema
class Task(BaseModel):
    title: str = Field(..., min_length=5, max_length=30, description="Title of the task", examples=["Learn FastAPI"])
    description: Optional[str] = None

# Task Create Schema
class TaskCreate(Task):
    completed: bool = Field(default=False, description="Task completion status")
    tags: Optional[list[str]] = Field(default_factory=list, description="List of tags associated with the task")

# Task Update Schema
class TaskUpdate(Task):
    completed: Optional[bool] = None 

# Task Response Schema
class TaskResponse(Task):
    id: int = Field(...)
    completed: bool
    tags: Optional[list[str]] = None
    created_at: datetime
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True 



