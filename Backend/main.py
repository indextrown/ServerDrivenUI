from fastapi import FastAPI
import uvicorn
from pydantic import BaseModel

app = FastAPI()

# 1번 방식: pydantic
class MessageResponse(BaseModel):
    message: str
    status: str
    
@app.get("/message", response_model=MessageResponse)
def message():
    return MessageResponse(
        message="Hello message",
        status="success"
    )

# 2번 방식: 딕셔너리
@app.get("/")
def root():
    return {"message": "Hello World"}

# pet-listings
@app.get("/pet-listing")
def get_pet_listings():
    return {
        "pageTitle": "Pets",
        "components": [
            {
                "type": "featuredImage",
                "data": {
                    "imageUrl": "https://images.unsplash.com/photo-1517331156700-3c241d2b4d83"
                }
            }
        ]
    }


if __name__ == "__main__":
    print("Server is running...")
    uvicorn.run("main:app", host="0.0.0.0", port=3000, reload=True)