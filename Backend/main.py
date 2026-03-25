from fastapi import FastAPI
import uvicorn
from pydantic import BaseModel

app = FastAPI()

# 1번 방식: pydantic
class MessageResponse(BaseModel):
    message: str
    status: str
    
pets = [
    {
        "petId": 1,
        "imageUrl": "https://images.unsplash.com/photo-1589883661923-6476cb0ae9f2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2574&q=80",
        "description": "햇살이 부드럽게 내려오는 창가에서 여유롭게 낮잠을 즐기는 고양이입니다. 사람을 잘 따르며 조용한 환경을 좋아하는 성격으로, 하루의 대부분을 편안하게 보내는 것을 선호합니다.",
        "rating": 5
    },
    {
        "petId": 2,
        "imageUrl": "https://images.unsplash.com/photo-1596854407944-bf87f6fdd49e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1160&q=80",
        "description": "주인을 바라보며 반갑게 꼬리를 흔드는 활발한 강아지입니다. 산책과 놀이를 좋아하며, 새로운 사람들과도 금방 친해지는 밝은 성격을 가지고 있습니다.",
        "rating": 4
    },
    {
        "petId": 3,
        "imageUrl": "https://images.unsplash.com/photo-1529257414772-1960b7bea4eb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80",
        "description": "호기심이 많아 주변을 탐색하는 것을 좋아하는 고양이입니다. 새로운 물건이나 환경에 대한 관심이 높으며, 장난감과 함께하는 시간을 특히 즐깁니다.",
        "rating": 3
    },
    {
        "petId": 4,
        "imageUrl": "https://images.unsplash.com/photo-1491485880348-85d48a9e5312?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80",
        "description": "넓은 공간에서 자유롭게 뛰어노는 것을 좋아하는 에너지 넘치는 강아지입니다. 활동량이 많아 충분한 운동이 필요하며, 함께하는 시간에 큰 행복을 느낍니다.",
        "rating": 5
    },
    {
        "petId": 5,
        "imageUrl": "https://images.unsplash.com/photo-1533743983669-94fa5c4338ec?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1392&q=80",
        "description": "포근한 분위기 속에서 쉬는 것을 좋아하는 반려동물입니다. 사람 곁에 조용히 머무르며 안정감을 주는 성격으로, 편안한 동반자가 되어줍니다.",
        "rating": 5
    }
]

# 2, 4이부분을 루트 매개 변수라고 하는데 원하는 건 뭐든 가질 수 있다
# pet-detail/:petId
# pet-detail/2
# pet-detail/4
@app.get("/pet-detail/{petId}")
def get_pet_detail(petId: int):
    
    # pet 찾기 (JS의 find)
    pet = next((p for p in pets if p["petId"] == petId), None)
    
    if pet is None:
        return {"error": "Pet not found"}
    
    return {
        "pageTitle": "Pet Detail",
        "components": [
            {
                "type": "featuredImage",
                "data": {
                    "imageUrl": pet["imageUrl"]
                }
            },
            {
                "type": "textRow",  
                "data": {
                    "text": pet["description"]
                }
            },
            {
                "type": "ratingRow",  
                "data": {
                    "rating": pet["rating"]
                }
            }
        ]
    }
    
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
        },
        {
            "type": "carousel",
            "data": {
                "items": [
                    {
                        "petId": pet["petId"],
                        "imageUrl": pet["imageUrl"]
                    }
                    for pet in pets
                ],
                "action": {
                    "type": "sheet",
                    "destination": "petDetail"
                }
            }
        },
        {
            "type": "featuredImage",
            "data": {
                "imageUrl": "https://images.unsplash.com/photo-1533743983669-94fa5c4338ec?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1392&q=80"
            }
        },
    ]
}


if __name__ == "__main__":
    print("Server is running...")
    uvicorn.run("main:app", host="0.0.0.0", port=3000, reload=True)
    
