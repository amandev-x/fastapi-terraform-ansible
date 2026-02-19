from fastapi import FastAPI, HTTPException, status, Depends, Path
from sqlalchemy import func
from sqlalchemy.orm import session
from app.schemas import TaskCreate, TaskUpdate, TaskResponse
from typing import List, Optional

from app.database import engine, get_db, Base
from app.models import Task

# Create database tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Task Management API",
    description="A simple task management system",
    version="1.0.0"
)

# Root endpoint
@app.get("/")
async def read_root():
    return {
        "message": "Task Management API is running",
        "version": "1.0.0",
        "status": "healthy"
    }

# Healthcheck endpoint
@app.get("/health")
async def health_check():
    return {"status": "healthy"}

# Task Create
@app.post("/tasks", response_model=TaskResponse, status_code=status.HTTP_201_CREATED)
async def create_task(task: TaskCreate, db: session = Depends(get_db)):
    # Task name must be unique
    existing_task = db.query(Task).filter(func.lower(Task.title) == task.title.lower()).first()
    if existing_task:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Task with this title already exists"
        )
    
    task_data = task.model_dump(exclude={"tags"})
    new_task = Task(**task_data)

    db.add(new_task)
    db.commit()
    db.refresh(new_task)

    return new_task

# Task Read All
@app.get("/tasks", response_model=List[TaskResponse])
async def read_tasks(skip: int = 0, limit: int = 100, db: session = Depends(get_db)):
    tasks = db.query(Task).offset(skip).limit(limit).all()
    return tasks 

# Task by ID
@app.get("/tasks/{task_id}", response_model=TaskResponse)
async def get_task_by_id(db: session = Depends(get_db), task_id: int = Path(..., description="Task ID", gt=0)):
    # Check if task exists using task id
    task = db.query(Task).filter(Task.id == task_id).first()

    if not task:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Task with ID {task_id} not found"
        )
    
    return task 

# Task Update
@app.put("/tasks/{task_id}", response_model=TaskResponse)
async def update_task(task_id: int, task_update: TaskUpdate, db: session = Depends(get_db)):
    task = db.query(Task).filter(Task.id == task_id).first()

    if not task:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Task with ID {task_id} not found"
        )
    
    # Update fields
    for key, value in task_update.model_dump(exclude_unset=True).items():
        setattr(task, key, value)

    db.commit()
    db.refresh(task)

    return task

# Task Delete
@app.delete("/tasks/{task_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_task(task_id: int, db: session = Depends(get_db)):
    task = db.query(Task).filter(Task.id == task_id).first()

    if not task:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Task with ID {task_id} not found"
        )
    
    db.delete(task)
    db.commit()

    return {"message": "Task deleted successfully"}
