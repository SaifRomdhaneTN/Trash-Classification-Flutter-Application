from fastapi import FastAPI, UploadFile, File
from PIL import Image
import torch
import torch.nn as nn
from torchvision import models, transforms
import io
from fastapi.middleware.cors import CORSMiddleware

# Initialize app
app = FastAPI()


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


# Load the model
model = models.resnet50(pretrained=False)
num_ftrs = model.fc.in_features
model.fc = nn.Linear(num_ftrs, 2)
model.load_state_dict(torch.load('resnet50_trash_classifier.pth', map_location=torch.device('cpu')))
model.eval()


class_names = ['clean', 'dirty']  # Adjust if needed


transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
])

# API endpoint
@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    image_bytes = await file.read()
    image = Image.open(io.BytesIO(image_bytes)).convert('RGB')

    image = transform(image).unsqueeze(0)  # Add batch dimension

    with torch.no_grad():
        outputs = model(image)
        _, predicted = torch.max(outputs, 1)

    label = class_names[predicted.item()]
    return {"label": label}

# To run the API:
# uvicorn app:app --reload
