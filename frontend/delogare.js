function checkAuthentication() {
    var token = checkCookie('token');
    if (token) {
        // exista si nu e gol
        return true;
    } else {
        return false;
    }
}

function checkCookie(name) {
    const cookies = document.cookie.split(';');
    
    for (let cookie of cookies) {
        const [cookieName, cookieValue] = cookie.split('=');
        if (cookieName.trim() === name) {
            return true; 
        }
    }
    
    return false;
}

function getUserRole() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', 'http://localhost:3000/current_user_role', true); 
    var token = getCookie('token'); 
    xhr.setRequestHeader('Authorization', token);
    console.log("Apelez getUserRole()");
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) { 
        if (xhr.status === 200) { 
            var response = JSON.parse(xhr.responseText);
            displayContentBasedOnRole(response.role);
        } else {
            console.error('Eroare la obținerea rolului utilizatorului:', xhr.status);
        }
        }
    };
    xhr.send(); 
}

function AscundeButoane(){
    const updateButonsUsers = document.querySelectorAll('.users-update');
        const deleteButonsUsers = document.querySelectorAll('.users-delete');

        updateButonsUsers.forEach(button => button.style.display = 'none');
        deleteButonsUsers.forEach(button => button.style.display = 'none');

        const updateButtons = document.querySelectorAll('.microposts-delete');
        const deleteButtons = document.querySelectorAll('.microposts-update');
        
        updateButtons.forEach(button => button.style.display = 'none');
        deleteButtons.forEach(button => button.style.display = 'none');
}

function displayContentBasedOnRole(role) {
    if (role == 'admin') {
        document.getElementById('users-link').style.display = 'block';

        const updateButonsUsers = document.querySelectorAll('.users-update');
        const deleteButonsUsers = document.querySelectorAll('.users-delete');

        updateButonsUsers.forEach(button => button.style.display = 'block');
        deleteButonsUsers.forEach(button => button.style.display = 'block');

        const updateButtons = document.querySelectorAll('.microposts-delete');
        const deleteButtons = document.querySelectorAll('.microposts-update');
        
        updateButtons.forEach(button => button.style.display = 'block');
        deleteButtons.forEach(button => button.style.display = 'block');

    } 
    else if (role == 'manager') {
        document.getElementById('users-link').style.display = 'block';

        // Aici practic am si butoanele de la postari si de la useri
        const updateButtons = document.querySelectorAll('.microposts-delete');
        const deleteButtons = document.querySelectorAll('.microposts-update');
        
        updateButtons.forEach(button => button.style.display = 'none');
        deleteButtons.forEach(button => button.style.display = 'none');

        const updateButonsUsers = document.querySelectorAll('.users-update');
        const deleteButonsUsers = document.querySelectorAll('.users-delete');

        updateButonsUsers.forEach(button => button.style.display = 'block');
        deleteButonsUsers.forEach(button => button.style.display = 'block');

    } 
    else {
        //  utilizator obișnuit
        document.getElementById('users-link').style.display = 'none';                                    

        const updateButtons = document.querySelectorAll('.btn-delete');
        const deleteButtons = document.querySelectorAll('.btn-update');
        
        updateButtons.forEach(button => button.style.display = 'none');
        deleteButtons.forEach(button => button.style.display = 'none');

    }
}

function updateLogoutButton() {
    const logoutButton = document.getElementById('logout-button');
    if (checkAuthentication()) {
        logoutButton.style.display = 'block';
    } else {
        logoutButton.style.display = 'none'; 
    }
}

function updateLoginLink() {
    const LoginLink = document.getElementById("login-link");
    if(checkAuthentication()){
        LoginLink.style.display = 'none';
    } else {
        LoginLink.style.display = 'block';
    }
}

function updateCreateMicropostLink() {
    const CreateMicropostLink = document.getElementById("create_micropost-link");
    if(!checkAuthentication()){
        CreateMicropostLink.style.display = 'none';
    } else {
        CreateMicropostLink.style.display = 'block';
    }
}

function updateSignupLink() {
    const LoginLink = document.getElementById("signup-link");
    if(checkAuthentication()){
        LoginLink.style.display = 'none';
    } else {
        LoginLink.style.display = 'block';
    }
}

function updateProfileLink(){
    const ProfileLink = document.getElementById("current_user-link");
    if(checkAuthentication()){
        ProfileLink.style.display = 'block';
    }
    else{
        ProfileLink.style.display = 'none';
    }
}

function updateUsersLink(){
    const ProfileLink = document.getElementById("users-link");
    if(checkAuthentication()){
        ProfileLink.style.display = 'block';
    }
    else{
        ProfileLink.style.display = 'none';
    }
}

function init() {
    // la incarcarea paginii ajustam butoanele in functie de rol si starea autentificarii
    // AscundeButoane();
    updateLogoutButton();
    updateLoginLink();
    updateSignupLink(); 
    updateCreateMicropostLink();
    updateProfileLink();
    updateUsersLink();
    if(checkAuthentication()){
        getUserRole();
    }
}

document.addEventListener('DOMContentLoaded', init);

// Log out - tratare eveniment
document.getElementById('logout-button').addEventListener('click', function(event) {
    event.preventDefault(); 

    document.cookie = 'token=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
    
    updateLogoutButton();
    
    document.cookie = "logoutMessage=You are logged out!; path=/";

    window.location.href = 'login.html'; 
});